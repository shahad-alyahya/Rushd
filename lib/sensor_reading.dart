import 'package:cloud_firestore/cloud_firestore.dart';

class SensorReading {
  final String id;
  final String zoneId;
  final String locationId;
  final String deviceId;
  final int entryCount;
  final int exitCount;
  final int? inside;
  final Timestamp timestamp;
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