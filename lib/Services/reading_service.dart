import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isListening = false;

  void startListening() {
    if (_isListening) return;
    _isListening = true;

    syncLatestReading();

    _firestore
        .collection('sensor_readings')
        .where('status', isEqualTo: 'received')
        .snapshots()
        .listen((snapshot) {
          for (final change in snapshot.docChanges) {
            if (change.type == DocumentChangeType.added) {
              processReading(change.doc.id);
            }
          }
        });
  }

  Future<void> syncLatestReading() async {
    final snapshot = await _firestore
        .collection('sensor_readings')
        .where('status', isEqualTo: 'received')
        .orderBy('timestamp', descending: false)
        .get();

    if (snapshot.docs.isEmpty) return;

    for (final doc in snapshot.docs) {
      await processReading(doc.id);
    }
  }

  Future<void> processReading(String readingId) async {
    final readingRef = _firestore.collection('sensor_readings').doc(readingId);

    await _firestore.runTransaction((transaction) async {
      final readingSnap = await transaction.get(readingRef);
      if (!readingSnap.exists) return;

      final readingData = readingSnap.data();
      if (readingData == null) return;

      final String status = (readingData['status'] ?? '').toString();
      if (status != 'received') return;

      final Timestamp? readingTimestamp =
          readingData['timestamp'] as Timestamp?;

      final String zoneId = (readingData['zoneId'] ?? '').toString();
      final String locationId = (readingData['locationId'] ?? '').toString();

      final int? inside = readingData['inside'] == null
          ? null
          : ((readingData['inside'] as num).toInt());

      if (zoneId.isEmpty || locationId.isEmpty) return;
      if (inside == null || inside < 0) return;

      final zoneRef = _firestore.collection('zones').doc(zoneId);
      final zoneSnap = await transaction.get(zoneRef);
      if (!zoneSnap.exists) return;

      final zoneData = zoneSnap.data();
      if (zoneData == null) return;

      final Timestamp? lastReadingTimestamp =
          zoneData['lastReadingTimestamp'] as Timestamp?;

      if (readingTimestamp != null &&
          lastReadingTimestamp != null &&
          readingTimestamp.compareTo(lastReadingTimestamp) <= 0) {
        transaction.update(readingRef, {'status': 'processed'});
        return;
      }

      final int capacity = ((zoneData['capacity'] ?? 0) as num).toInt();
      final double areaSize = ((zoneData['areaSize'] ?? 0) as num).toDouble();

      final double lowThreshold = ((zoneData['lowThreshold'] ?? 0.3) as num)
          .toDouble();
      final double mediumThreshold =
          ((zoneData['mediumThreshold'] ?? 0.7) as num).toDouble();

      final int newCurrentCount = inside;

      double density = 0.0;
      if (capacity > 0) {
        density = newCurrentCount / capacity;
      } else if (areaSize > 0) {
        density = newCurrentCount / areaSize;
      }

      final double roundedDensity = double.parse(density.toStringAsFixed(2));

      String congestionLevel;
      if (density < lowThreshold) {
        congestionLevel = 'low';
      } else if (density < mediumThreshold) {
        congestionLevel = 'medium';
      } else {
        congestionLevel = 'high';
      }
      await _handleAlert(
        zoneId: zoneId,
        locationId: locationId,
        zoneName: (zoneData['zoneName'] ?? '').toString(),
        congestionLevel: congestionLevel,
        severity: congestionLevel == 'high' ? 'high' : 'medium',
      );
      transaction.update(zoneRef, {
        'currentCount': newCurrentCount,
        'density': roundedDensity,
        'congestionLevel': congestionLevel,
        'lastReadingId': readingId,
        'lastReadingTimestamp': readingTimestamp,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      transaction.update(readingRef, {'status': 'processed'});
    });
  }

  Future<void> _handleAlert({
    required String zoneId,
    required String locationId,
    required String zoneName,
    required String congestionLevel,
    required String severity,
  }) async {
    final alertsQuery = await _firestore
        .collection('alerts')
        .where('zoneId', isEqualTo: zoneId)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();

    if (congestionLevel == 'high') {
      if (alertsQuery.docs.isNotEmpty) {
        await alertsQuery.docs.first.reference.update({
          'locationId': locationId,
          'zoneName': zoneName,
          'congestionLevel': congestionLevel,
          'severity': severity,
          'message': 'High congestion detected in $zoneName',
          'status': 'active',
          'respondedAt': null,
          'respondedBy': '',
        });
      } else {
        await _firestore.collection('alerts').add({
          'zoneId': zoneId,
          'locationId': locationId,
          'zoneName': zoneName,
          'congestionLevel': congestionLevel,
          'severity': severity,
          'message': 'High congestion detected in $zoneName',
          'status': 'active',
          'createdAt': FieldValue.serverTimestamp(),
          'respondedAt': null,
          'respondedBy': '',
        });
      }
    } else {
      if (alertsQuery.docs.isNotEmpty) {
        await alertsQuery.docs.first.reference.update({
          'status': 'resolved',
          'respondedAt': FieldValue.serverTimestamp(),
          'respondedBy': '',
        });
      }
    }
  }

  Future<void> updateStatistics(String locationId) async {
    final zonesSnap = await _firestore
        .collection('zones')
        .where('locationId', isEqualTo: locationId)
        .get();

    if (zonesSnap.docs.isEmpty) return;

    final usersSnap = await _firestore
        .collection('users')
        .where('assignedLocationId', isEqualTo: locationId)
        .get();

    int totalVisitors = 0;
    double densitySum = 0.0;

    String mostCrowdedZone = '';
    String leastCrowdedZone = '';
    double maxDensity = -1;
    double minDensity = double.infinity;
    int totalSecurity = 0;

    for (final userDoc in usersSnap.docs) {
      final userData = userDoc.data();
      final String role = (userData['role'] ?? '').toString().toLowerCase();
      final String status = (userData['status'] ?? 'active')
          .toString()
          .toLowerCase();

      if (role == 'security' && status == 'active') {
        totalSecurity++;
      }
    }

    for (final doc in zonesSnap.docs) {
      final data = doc.data();
      final int currentCount = ((data['currentCount'] ?? 0) as num).toInt();
      final double density = ((data['density'] ?? 0) as num).toDouble();
      final String zoneName = ((data['zoneName'] ?? data['areaName']) ?? '')
          .toString();

      totalVisitors += currentCount;
      densitySum += density;

      if (density > maxDensity) {
        maxDensity = density;
        mostCrowdedZone = zoneName;
      }

      if (density < minDensity) {
        minDensity = density;
        leastCrowdedZone = zoneName;
      }
    }

    final double averageDensity = zonesSnap.docs.isNotEmpty
        ? double.parse((densitySum / zonesSnap.docs.length).toStringAsFixed(2))
        : 0.0;

    final now = DateTime.now();
    final String date = now.toIso8601String().split('T').first;
    final String month = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final String year = '${now.year}';

    final existingStatsQuery = await _firestore
        .collection('statistics')
        .where('locationId', isEqualTo: locationId)
        .where('periodType', isEqualTo: 'day')
        .where('date', isEqualTo: date)
        .limit(1)
        .get();

    final statsData = {
      'locationId': locationId,
      'periodType': 'day',
      'date': date,
      'month': month,
      'year': year,
      'totalVisitors': totalVisitors,
      'totalZones': zonesSnap.docs.length,
      'totalSecurity': totalSecurity,
      'averageDensity': averageDensity,
      'mostCrowdedZone': mostCrowdedZone,
      'leastCrowdedZone': leastCrowdedZone,
      'lastUpdated': FieldValue.serverTimestamp(),
    };

    if (existingStatsQuery.docs.isNotEmpty) {
      await existingStatsQuery.docs.first.reference.update(statsData);
    } else {
      await _firestore.collection('statistics').add(statsData);
    }
  }

  Future<void> respondToAlert({
    required String alertId,
    required String securityUserId,
  }) async {
    await _firestore.collection('alerts').doc(alertId).update({
      'status': 'responded',
      'respondedAt': FieldValue.serverTimestamp(),
      'respondedBy': securityUserId,
    });
  }
}
