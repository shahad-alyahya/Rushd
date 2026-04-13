import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_data.dart';

enum CrowdLevel {
  low,
  medium,
  high,
  unknown,
}

class ZoneStatus {
  final String id;
  final String name;
  final CrowdLevel crowdLevel;
  final int visitorCount;
  final String lastUpdated;
  final String? imagePath;

  const ZoneStatus({
    required this.id,
    required this.name,
    required this.crowdLevel,
    required this.visitorCount,
    required this.lastUpdated,
    this.imagePath,
  });

  factory ZoneStatus.fromMap(Map<String, dynamic> map) {
    return ZoneStatus(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      crowdLevel: ZoneLogic.parseCrowdLevel(map['crowdLevel']),
      visitorCount: _parseInt(map['visitorCount']),
      lastUpdated: map['lastUpdated']?.toString() ?? '--',
      imagePath: map['imagePath']?.toString(),
    );
  }

  ZoneStatus copyWith({
    String? id,
    String? name,
    CrowdLevel? crowdLevel,
    int? visitorCount,
    String? lastUpdated,
    String? imagePath,
  }) {
    return ZoneStatus(
      id: id ?? this.id,
      name: name ?? this.name,
      crowdLevel: crowdLevel ?? this.crowdLevel,
      visitorCount: visitorCount ?? this.visitorCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class ZoneLogic {
  static List<ZoneStatus> _zones = [
    const ZoneStatus(
      id: 'saudia',
      name: 'Saudi Arabia Zone',
      crowdLevel: CrowdLevel.low,
      visitorCount: 120,
      lastUpdated: '9:12 PM',
    ),
    const ZoneStatus(
      id: 'china',
      name: 'China Zone',
      crowdLevel: CrowdLevel.medium,
      visitorCount: 210,
      lastUpdated: '9:12 PM',
    ),
    const ZoneStatus(
      id: 'sham',
      name: 'Sham Zone',
      crowdLevel: CrowdLevel.low,
      visitorCount: 320,
      lastUpdated: '9:12 PM',
    ),
    const ZoneStatus(
      id: 'moroco',
      name: 'Morocco Zone',
      crowdLevel: CrowdLevel.low,
      visitorCount: 95,
      lastUpdated: '9:12 PM',
    ),
    const ZoneStatus(
      id: 'italy',
      name: 'Italy Zone',
      crowdLevel: CrowdLevel.medium,
      visitorCount: 180,
      lastUpdated: '9:12 PM',
    ),
    const ZoneStatus(
      id: 'kuwait',
      name: 'Kuwait Zone',
      crowdLevel: CrowdLevel.high,
      visitorCount: 200,
      lastUpdated: '9:12 PM',
    ),
    const ZoneStatus(
      id: 'greece',
      name: 'Greece Zone',
      crowdLevel: CrowdLevel.medium,
      visitorCount: 165,
      lastUpdated: '9:12 PM',
    ),
    const ZoneStatus(
      id: 'Egypt',
      name: 'Egypt Zone',
      crowdLevel: CrowdLevel.low,
      visitorCount: 110,
      lastUpdated: '9:12 PM',
    ),
    const ZoneStatus(
      id: 'turky',
      name: 'Turkey Zone',
      crowdLevel: CrowdLevel.high,
      visitorCount: 300,
      lastUpdated: '9:12 PM',
    ),
    const ZoneStatus(
      id: 'Spain',
      name: 'Spain Zone',
      crowdLevel: CrowdLevel.low,
      visitorCount: 105,
      lastUpdated: '9:12 PM',
    ),
    const ZoneStatus(
      id: 'US',
      name: 'US Zone',
      crowdLevel: CrowdLevel.medium,
      visitorCount: 220,
      lastUpdated: '9:12 PM',
    ),
    const ZoneStatus(
      id: 'japan',
      name: 'Japan Zone',
      crowdLevel: CrowdLevel.low,
      visitorCount: 90,
      lastUpdated: '9:12 PM',
    ),
    const ZoneStatus(
      id: 'india',
      name: 'India Zone',
      crowdLevel: CrowdLevel.high,
      visitorCount: 340,
      lastUpdated: '9:12 PM',
    ),
  ];

  static CrowdLevel parseCrowdLevel(dynamic value) {
    final text = value?.toString().toLowerCase().trim() ?? '';

    switch (text) {
      case 'low':
        return CrowdLevel.low;
      case 'medium':
        return CrowdLevel.medium;
      case 'high':
        return CrowdLevel.high;
      default:
        return CrowdLevel.unknown;
    }
  }static String crowdLevelToText(CrowdLevel level) {
    switch (level) {
      case CrowdLevel.low:
        return 'low';
      case CrowdLevel.medium:
        return 'medium';
      case CrowdLevel.high:
        return 'high';
      case CrowdLevel.unknown:
        return 'unknown';
    }
  }

  static Color getZoneColorByCrowdLevel(CrowdLevel level) {
    switch (level) {
      case CrowdLevel.low:
        return const Color.fromARGB(120, 80, 200, 120);
      case CrowdLevel.medium:
        return const Color.fromARGB(120, 255, 200, 80);
      case CrowdLevel.high:
        return const Color.fromARGB(120, 220, 80, 80);
      case CrowdLevel.unknown:
        return const Color.fromARGB(80, 180, 180, 180);
    }
  }

  static Color getZoneColorById(String zoneId) {
    final zone = getZoneById(zoneId);
    return getZoneColorByCrowdLevel(zone?.crowdLevel ?? CrowdLevel.unknown);
  }

  static ZoneStatus? getZoneById(String zoneId) {
    try {
      return _zones.firstWhere((zone) => zone.id == zoneId);
    } catch (_) {
      return null;
    }
  }

  static List<ZoneStatus> getAllZones() {
    return List.unmodifiable(_zones);
  }

  static List<ZoneStatus> getZonesByCrowdLevel(CrowdLevel level) {
    return _zones.where((zone) => zone.crowdLevel == level).toList();
  }

  static List<ZoneStatus> getLowCrowdZones() {
    return getZonesByCrowdLevel(CrowdLevel.low);
  }

  static List<ZoneStatus> getMediumCrowdZones() {
    return getZonesByCrowdLevel(CrowdLevel.medium);
  }

  static List<ZoneStatus> getHighCrowdZones() {
    return getZonesByCrowdLevel(CrowdLevel.high);
  }

  static double _distance(LatLng a, LatLng b) {
    final dx = a.latitude - b.latitude;
    final dy = a.longitude - b.longitude;
    return dx * dx + dy * dy;
  }

  static LatLng? getZoneCenter(String zoneId) {
    return MapData.zoneLabelCenters[zoneId];
  }

  static List<ZoneStatus> getBestNearbyZones({
    required LatLng userLocation,
    int limit = 3,
  }) {
    final lowZones = getLowCrowdZones();

    lowZones.sort((a, b) {
      final aCenter = getZoneCenter(a.id);
      final bCenter = getZoneCenter(b.id);

      if (aCenter == null && bCenter == null) return 0;
      if (aCenter == null) return 1;
      if (bCenter == null) return -1;

      final aDistance = _distance(userLocation, aCenter);
      final bDistance = _distance(userLocation, bCenter);

      return aDistance.compareTo(bDistance);
    });

    return lowZones.take(limit).toList();
  }

  static ZoneStatus? getBestAlternativeZone({
    required LatLng userLocation,
  }) {
    final zones = getBestNearbyZones(
      userLocation: userLocation,
      limit: 1,
    );

    if (zones.isEmpty) return null;
    return zones.first;
  }

  static void updateZonesFromMap(List<Map<String, dynamic>> zonesData) {
    _zones = zonesData.map((zoneMap) => ZoneStatus.fromMap(zoneMap)).toList();
  }

  static void updateSingleZone({
    required String zoneId,
    CrowdLevel? crowdLevel,
    int? visitorCount,
    String? lastUpdated,
    String? imagePath,
  }) {
    _zones = _zones.map((zone) {
      if (zone.id != zoneId) return zone;

      return zone.copyWith(
        crowdLevel: crowdLevel,
        visitorCount: visitorCount,
        lastUpdated: lastUpdated,
        imagePath: imagePath,
      );
    }).toList();
  }

  static List<Map<String, dynamic>> toFirebaseLikeMapList() {
    return _zones.map((zone) {
      return {
        'id': zone.id,
        'name': zone.name,
        'crowdLevel': crowdLevelToText(zone.crowdLevel),
        'visitorCount': zone.visitorCount,
        'lastUpdated': zone.lastUpdated,
        'imagePath': zone.imagePath,
      };
    }).toList();
  }
}