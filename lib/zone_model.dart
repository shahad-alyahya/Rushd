import 'package:cloud_firestore/cloud_firestore.dart';

/// A data model representing a specific physical zone or area within a location.
class ZoneModel {
  // Unique identifier for the zone.
  final String id;

  // The ID of the broader location this zone belongs to.
  final String locationId;

  // The display name of the zone.
  final String zoneName;

  // An optional specific area name within the zone.
  final String? areaName;

  // The physical size of the area (used for density calculations if capacity is unknown).
  final double areaSize;

  // The maximum allowed number of people in this zone.
  final int capacity;

  // The current number of people inside, updated continuously by sensor readings.
  final int currentCount;

  // The calculated crowd density.
  final double density;

  // The current state of crowding (e.g., 'low', 'medium', 'high').
  final String congestionLevel;

  // Threshold limits used to determine the current congestion level.
  final double lowThreshold;
  final double mediumThreshold;

  // The threshold that triggers a high-congestion alert when exceeded.
  final double highThreshold;

  // The exact timestamp when this zone's metrics were last updated.
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

  // Factory constructor to safely parse a Firestore data map into a ZoneModel object.
  // It provides safe fallback defaults (like 0 for numbers or 'low' for congestion) to prevent crashes.
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
