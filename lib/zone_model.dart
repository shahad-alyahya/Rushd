import 'package:cloud_firestore/cloud_firestore.dart';

class ZoneModel {
  final String id;
  final String locationId;
  final String zoneName;
  final String? areaName;
  final double areaSize;
  final int capacity;
  final int currentCount;
  final double density;
  final String congestionLevel;
  final double lowThreshold;
  final double mediumThreshold;
  final double highThreshold;
  final Timestamp? lastUpdated;

  ZoneModel({
    required this.id,
    required this.locationId,
    required this.zoneName,
    required this.areaName,
    required this.areaSize,
    required this.capacity,
    required this.currentCount,
    required this.density,
    required this.congestionLevel,
    required this.lowThreshold,
    required this.mediumThreshold,
    required this.highThreshold,
    required this.lastUpdated,
  });

  factory ZoneModel.fromMap(String id, Map<String, dynamic> data) {
    return ZoneModel(
      id: id,
      locationId: (data['locationId'] ?? '') as String,
      zoneName: ((data['zoneName'] ?? data['areaName']) ?? id) as String,
      areaName: data['areaName'] as String?,
      areaSize: ((data['areaSize'] ?? 0) as num).toDouble(),
      capacity: ((data['capacity'] ?? 0) as num).toInt(),
      currentCount: ((data['currentCount'] ?? 0) as num).toInt(),
      density: ((data['density'] ?? 0) as num).toDouble(),
      congestionLevel: (data['congestionLevel'] ?? 'low') as String,
      lowThreshold: ((data['lowThreshold'] ?? 0.3) as num).toDouble(),
      mediumThreshold: ((data['mediumThreshold'] ?? 0.7) as num).toDouble(),
      highThreshold: ((data['highThreshold'] ?? 1.0) as num).toDouble(),
      lastUpdated: data['lastUpdated'] as Timestamp?,
    );
  }
}