import 'package:cloud_firestore/cloud_firestore.dart';
import 'calculation_utils.dart';
import 'processing_result.dart';
import 'sensor_reading.dart';
import 'zone_model.dart';

/// Centralized service for managing Firestore operations.
/// It listens to Arduino sensor readings, calculates zone metrics, manages congestion alerts, and updates daily statistics.
class RushdFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _zonesRef =>
      _firestore.collection('zones');

  CollectionReference<Map<String, dynamic>> get _sensorReadingsRef =>
      _firestore.collection('sensor_readings');

  CollectionReference<Map<String, dynamic>> get _alertsRef =>
      _firestore.collection('alerts');

  CollectionReference<Map<String, dynamic>> get _statisticsRef =>
      _firestore.collection('statistics');

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  // Listens continuously for new sensor readings from the Arduino that have the status 'received'.
  Stream<QuerySnapshot<Map<String, dynamic>>> listenForNewReadings() {
    return _sensorReadingsRef
        .where('status', isEqualTo: 'received')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Main execution flow: Processes the reading securely, checks for alerts, and updates statistics.
  Future<void> processReading(SensorReading reading) async {
    final ProcessingResult? result = await _processReadingTransaction(reading);

    if (result == null || !result.processed) return;

    await _upsertAlert(result);
    await refreshStatisticsForLocation(
      locationId: result.locationId,
      readingTimestamp: reading.timestamp.toDate(),
    );
  }

  // A secure database transaction that calculates metrics and updates Firestore.
  Future<ProcessingResult?> _processReadingTransaction(
    SensorReading reading,
  ) async {
    final zoneRef = _zonesRef.doc(reading.zoneId);
    final readingRef = _sensorReadingsRef.doc(reading.id);

    ProcessingResult? result;

    await _firestore.runTransaction((transaction) async {
      // 1. Fetch the reading document securely within the transaction.
      final readingSnap = await transaction.get(readingRef);

      if (!readingSnap.exists) {
        throw Exception('Reading does not exist: ${reading.id}');
      }

      final readingData = readingSnap.data();

      if (readingData == null) {
        throw Exception('Reading data is null: ${reading.id}');
      }

      // 2. Prevent duplicate processing if the status is already 'processed'.
      if (readingData['status'] == 'processed') {
        result = null;
        return;
      }

      final currentStatus = (readingData['status'] ?? 'received') as String;

      if (currentStatus != 'received') {
        result = null;
        return;
      }

      // 3. Fetch the zone document to get current capacity and thresholds.
      final zoneSnap = await transaction.get(zoneRef);

      if (!zoneSnap.exists) {
        transaction.update(readingRef, {
          'status': 'failed',
          'failureReason': 'Zone not found',
          'processedAt': FieldValue.serverTimestamp(),
        });
        result = null;
        return;
      }

      final zoneData = zoneSnap.data();

      if (zoneData == null) {
        transaction.update(readingRef, {
          'status': 'failed',
          'failureReason': 'Zone data is null',
          'processedAt': FieldValue.serverTimestamp(),
        });
        result = null;
        return;
      }

      final zone = ZoneModel.fromMap(zoneSnap.id, zoneData);

      // 4. Calculate the net change in visitors based on Arduino entry and exit sensor data.
      final int netCountChange = CalculationUtils.calculateNetCount(
        entryCount: reading.entryCount,
        exitCount: reading.exitCount,
      );

      // 5. Update the current visitor count for the zone.
      final int newCurrentCount =
          CalculationUtils.calculateCurrentCountFromInside(
            inside: reading.inside,
            oldCount: zone.currentCount,
            netChange: netCountChange,
          );

      // 6. Calculate density and determine the congestion and severity levels.
      final double density = CalculationUtils.calculateDensity(
        currentCount: newCurrentCount,
        capacity: zone.capacity,
        areaSize: zone.areaSize,
      );

      final double roundedDensity = CalculationUtils.roundTo2(density);

      final String congestionLevel = CalculationUtils.calculateCongestionLevel(
        density: density,
        lowThreshold: zone.lowThreshold,
        mediumThreshold: zone.mediumThreshold,
      );

      final String severity = CalculationUtils.calculateSeverity(
        density: density,
        highThreshold: zone.highThreshold,
      );

      // 7. Update the zone document with the newly calculated metrics.
      transaction.update(zoneRef, {
        'currentCount': newCurrentCount,
        'density': roundedDensity,
        'congestionLevel': congestionLevel,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // 8. Mark the reading as processed and store the snapshot of the metrics after processing.
      transaction.update(readingRef, {
        'netCountChange': netCountChange,
        'currentCountAfterReading': newCurrentCount,
        'densityAfterReading': roundedDensity,
        'congestionLevelAfterReading': congestionLevel,
        'status': 'processed',
        'processedAt': FieldValue.serverTimestamp(),
      });

      result = ProcessingResult(
        processed: true,
        zoneId: zone.id,
        locationId: zone.locationId,
        zoneName: zone.zoneName,
        currentCount: newCurrentCount,
        density: roundedDensity,
        congestionLevel: congestionLevel,
        severity: severity,
      );
    });

    return result;
  }

  // Evaluates the calculated density to manage congestion alerts.
  Future<void> _upsertAlert(ProcessingResult result) async {
    // Check if there is already an active alert for this specific zone.
    final activeAlertQuery = await _alertsRef
        .where('zoneId', isEqualTo: result.zoneId)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();

    if (result.congestionLevel == 'high') {
      // If congestion is 'high', either update the existing alert or create a new one.
      if (activeAlertQuery.docs.isNotEmpty) {
        await activeAlertQuery.docs.first.reference.update({
          'locationId': result.locationId,
          'zoneName': result.zoneName,
          'congestionLevel': result.congestionLevel,
          'severity': 'high',
          'message': 'High congestion detected in ${result.zoneName}',
          'status': 'active',
          'respondedAt': null,
          'respondedBy': '',
        });
      } else {
        await _alertsRef.add({
          'zoneId': result.zoneId,
          'locationId': result.locationId,
          'zoneName': result.zoneName,
          'congestionLevel': result.congestionLevel,
          'severity': 'high',
          'message': 'High congestion detected in ${result.zoneName}',
          'status': 'active',
          'createdAt': FieldValue.serverTimestamp(),
          'respondedAt': null,
          'respondedBy': '',
        });
      }
    } else {
      // If congestion is normal, mark any active alert as resolved.
      if (activeAlertQuery.docs.isNotEmpty) {
        await activeAlertQuery.docs.first.reference.update({
          'status': 'resolved',
          'respondedAt': FieldValue.serverTimestamp(),
          'respondedBy': '',
        });
      }
    }
  }

  // Aggregates data for a specific location to update daily statistics.
  Future<void> refreshStatisticsForLocation({
    required String locationId,
    DateTime? readingTimestamp,
  }) async {
    // Define the 24-hour time window for the current day.
    final DateTime baseTime = readingTimestamp ?? DateTime.now();
    final DateTime startOfDay = DateTime(
      baseTime.year,
      baseTime.month,
      baseTime.day,
    );
    final DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    final String date = _formatDate(startOfDay);
    final String month =
        '${startOfDay.year}-${startOfDay.month.toString().padLeft(2, '0')}';
    final String year = startOfDay.year.toString();

    // Fetch related zones and active security personnel for the location.
    final zonesSnapshot = await _zonesRef
        .where('locationId', isEqualTo: locationId)
        .get();

    final usersSnapshot = await _usersRef
        .where('assignedLocationId', isEqualTo: locationId)
        .where('role', isEqualTo: 'security')
        .where('status', isEqualTo: 'active')
        .get();

    // Fetch all sensor readings for this location within the current day.
    final readingsSnapshot = await _sensorReadingsRef
        .where('locationId', isEqualTo: locationId)
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    // Calculate total visitors by summing up entry counts from all daily readings.
    int totalVisitors = 0;
    for (final doc in readingsSnapshot.docs) {
      final data = doc.data();
      totalVisitors += ((data['entryCount'] ?? 0) as num).toInt();
    }

    final int totalZones = zonesSnapshot.docs.length;
    final int totalSecurity = usersSnapshot.docs.length;

    // Check if a statistics document already exists for today.
    final existingStatsQuery = await _statisticsRef
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
      'totalZones': totalZones,
      'totalSecurity': totalSecurity,
      'lastUpdated': FieldValue.serverTimestamp(),
    };

    // Update the existing document or create a new one.
    if (existingStatsQuery.docs.isNotEmpty) {
      await existingStatsQuery.docs.first.reference.update(statsData);
    } else {
      await _statisticsRef.add(statsData);
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
