import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isListening = false;

  void startListening() {
    if (_isListening) return;
    _isListening = true;

    _firestore
        .collection('sensor_readings')
        .where('status', isEqualTo: 'received')
        .snapshots()
        .listen((snapshot) {
      for (final doc in snapshot.docs) {
        processReading(doc.id);
      }
    });
  }

  Future<void> processReading(String readingId) async {
    final readingRef = _firestore.collection('sensor_readings').doc(readingId);

    String? readingLocationId;

    await _firestore.runTransaction((transaction) async {
      final readingSnap = await transaction.get(readingRef);
      if (!readingSnap.exists) return;

      final readingData = readingSnap.data();
      if (readingData == null) return;

      final String status = (readingData['status'] ?? 'received').toString();
      if (status != 'received') return;

      final String zoneId = (readingData['zoneId'] ?? '').toString();
      final String locationId = (readingData['locationId'] ?? '').toString();
      final int entryCount = ((readingData['entryCount'] ?? 0) as num).toInt();
      final int exitCount = ((readingData['exitCount'] ?? 0) as num).toInt();
      final int? inside = readingData['inside'] == null
          ? null
          : ((readingData['inside'] as num).toInt());

      readingLocationId = locationId;

      if (zoneId.isEmpty || locationId.isEmpty) {
        transaction.update(readingRef, {
          'status': 'failed',
          'failureReason': 'Missing zoneId or locationId',
          'processedAt': FieldValue.serverTimestamp(),
        });
        return;
      }

      final zoneRef = _firestore.collection('zones').doc(zoneId);
      final zoneSnap = await transaction.get(zoneRef);

      if (!zoneSnap.exists) {
        transaction.update(readingRef, {
          'status': 'failed',
          'failureReason': 'Zone not found',
          'processedAt': FieldValue.serverTimestamp(),
        });
        return;
      }

      final zoneData = zoneSnap.data();
      if (zoneData == null) {
        transaction.update(readingRef, {
          'status': 'failed',
          'failureReason': 'Zone data is null',
          'processedAt': FieldValue.serverTimestamp(),
        });
        return;
      }

      final int oldCurrentCount = ((zoneData['currentCount'] ?? 0) as num).toInt();
      final int capacity = ((zoneData['capacity'] ?? 0) as num).toInt();
      final double areaSize = ((zoneData['areaSize'] ?? 0) as num).toDouble();

      final String zoneName =
          ((zoneData['zoneName'] ?? zoneData['areaName']) ?? 'Unknown Zone')
              .toString();

      final double lowThreshold =
          ((zoneData['lowThreshold'] ?? 0.3) as num).toDouble();
      final double mediumThreshold =
          ((zoneData['mediumThreshold'] ?? 0.7) as num).toDouble();
      final double highThreshold =
          ((zoneData['highThreshold'] ?? 1.0) as num).toDouble();

      final int netCountChange = entryCount - exitCount;

      int newCurrentCount;
      if (inside != null && inside >= 0) {
        newCurrentCount = inside;
      } else {
        newCurrentCount = oldCurrentCount + netCountChange;
        if (newCurrentCount < 0) newCurrentCount = 0;
      }

      double density = 0.0;
      if (capacity > 0) {
        density = newCurrentCount / capacity;
      } else if (areaSize > 0) {
        density = newCurrentCount / areaSize;
      }

      final double roundedDensity =
          double.parse(density.toStringAsFixed(2));

      String congestionLevel = 'low';
      if (density < lowThreshold) {
        congestionLevel = 'low';
      } else if (density < mediumThreshold) {
        congestionLevel = 'medium';
      } else {
        congestionLevel = 'high';
      }

      final String severity = density >= highThreshold ? 'high' : 'medium';

      transaction.update(zoneRef, {
        'currentCount': newCurrentCount,
        'density': roundedDensity,
        'congestionLevel': congestionLevel,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      transaction.update(readingRef, {
        'netCountChange': netCountChange,
        'currentCountAfterReading': newCurrentCount,
        'densityAfterReading': roundedDensity,
        'congestionLevelAfterReading': congestionLevel,
        'status': 'processed',
        'processedAt': FieldValue.serverTimestamp(),
      });

      if (congestionLevel == 'high') {
        final alertsQuery = await _firestore
            .collection('alerts')
            .where('zoneId', isEqualTo: zoneId)
            .where('status', isEqualTo: 'active')
            .limit(1)
            .get();

        if (alertsQuery.docs.isNotEmpty) {
          transaction.update(alertsQuery.docs.first.reference, {
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
          final alertRef = _firestore.collection('alerts').doc();
          transaction.set(alertRef, {
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
        final alertsQuery = await _firestore
            .collection('alerts')
            .where('zoneId', isEqualTo: zoneId)
            .where('status', isEqualTo: 'active')
            .limit(1)
            .get();

        if (alertsQuery.docs.isNotEmpty) {
          transaction.update(alertsQuery.docs.first.reference, {
            'status': 'resolved',
            'respondedAt': FieldValue.serverTimestamp(),
            'respondedBy': '',
          });
        }
      }
    });

    if (readingLocationId != null && readingLocationId!.isNotEmpty) {
      await updateStatistics(readingLocationId!);
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
      final String status = (userData['status'] ?? 'active').toString().toLowerCase();

      if (role == 'security' && status == 'active') {
        totalSecurity++;
      }
    }

    for (final doc in zonesSnap.docs) {
      final data = doc.data();
      final int currentCount = ((data['currentCount'] ?? 0) as num).toInt();
      final double density = ((data['density'] ?? 0) as num).toDouble();
      final String zoneName =
          ((data['zoneName'] ?? data['areaName']) ?? '').toString();

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

    final now = DateTime.
    now();
    final String date = now.toIso8601String().split('T').first;
    final String month =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';
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