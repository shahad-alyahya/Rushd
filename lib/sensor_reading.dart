import 'package:cloud_firestore/cloud_firestore.dart';

/// A data model representing a single reading from an Arduino sensor at the gates.
class SensorReading {
  // The unique Firestore document ID for this reading.
  final String id;

  // The ID of the specific zone where the sensor is located.
  final String zoneId;

  // The ID of the broader location.
  final String locationId;

  // The unique identifier for the specific Arduino device sending the data.
  final String deviceId;

  // The number of people who entered through the gate.
  final int entryCount;

  // The number of people who exited through the gate.
  final int exitCount;

  // The direct count of people currently inside (if directly provided by the sensor).
  final int? inside;

  // The exact date and time the reading was recorded.
  final Timestamp timestamp;

  // The current processing stage of this reading (e.g., 'received', 'processed', 'failed').
  final String status;

  SensorReading({
    required this.id,
    required this.zoneId,
    required this.locationId,
    required this.deviceId,
    required this.entryCount,
    required this.exitCount,
    required this.inside,
    required this.timestamp,
    required this.status,
  });

  // Factory constructor to safely parse a Firestore document snapshot into a SensorReading object.
  // It handles null values and provides safe defaults to prevent runtime crashes.
  factory SensorReading.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    if (data == null) {
      throw Exception('SensorReading document is empty: ${doc.id}');
    }

    return SensorReading(
      id: doc.id,
      zoneId: (data['zoneId'] ?? '') as String,
      locationId: (data['locationId'] ?? '') as String,
      deviceId: (data['deviceId'] ?? '') as String,
      entryCount: ((data['entryCount'] ?? 0) as num).toInt(),
      exitCount: ((data['exitCount'] ?? 0) as num).toInt(),
      inside: data['inside'] == null ? null : ((data['inside'] as num).toInt()),
      timestamp: (data['timestamp'] as Timestamp?) ?? Timestamp.now(),
      status: (data['status'] ?? 'received') as String,
    );
  }
}
