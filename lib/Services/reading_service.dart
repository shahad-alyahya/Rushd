import 'package:cloud_firestore/cloud_firestore.dart';

// Service to handle sensor data processing, density calculations, and alerts
class ReadingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isListening = false;
  // Starts real-time listening for new sensor readings with 'received' status
  void startListening() {
    if (_isListening) return;
    _isListening = true;
    // Process any missed readings first
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

  // Ensures all pending 'received' readings are processed sequentially
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

  //  Processes a single reading, calculates density, and updates zone status
  Future<void> processReading(String readingId) async {
    final readingRef = _firestore.collection('sensor_readings').doc(readingId);
    // Use a Transaction to ensure data consistency between reading and zone updates
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
      // Avoid processing out-of-order or duplicate data
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
      // Density calculation logic
      double density = 0.0;
      if (capacity > 0) {
        density = newCurrentCount / capacity;
      } else if (areaSize > 0) {
        density = newCurrentCount / areaSize;
      }

      final double roundedDensity = double.parse(density.toStringAsFixed(2));
      // Determine congestion level based on calculated density
      String congestionLevel;
      if (density < lowThreshold) {
        congestionLevel = 'low';
      } else if (density < mediumThreshold) {
        congestionLevel = 'medium';
      } else {
        congestionLevel = 'high';
      }
      // Handle alert creation or resolution
      await _handleAlert(
        zoneId: zoneId,
        locationId: locationId,
        zoneName: (zoneData['zoneName'] ?? '').toString(),
        congestionLevel: congestionLevel,
        severity: congestionLevel == 'high' ? 'high' : 'medium',
      );
      // Update the zone with new crowd data
      transaction.update(zoneRef, {
        'currentCount': newCurrentCount,
        'density': roundedDensity,
        'congestionLevel': congestionLevel,
        'lastReadingId': readingId,
        'lastReadingTimestamp': readingTimestamp,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      // Mark reading as processed
      transaction.update(readingRef, {'status': 'processed'});
    });
  }

  // Automates alert management for High congestion scenarios
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
      // Create or update active alert if congestion is high
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
      // Resolve existing alert if congestion level drops below High
      if (alertsQuery.docs.isNotEmpty) {
        await alertsQuery.docs.first.reference.update({
          'status': 'resolved',
          'respondedAt': FieldValue.serverTimestamp(),
          'respondedBy': '',
        });
      }
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
