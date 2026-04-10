import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_data.dart';

class RouteService {
  /// تبحث عن أقصر مسار بين نقطتين في شبكة الممرات
  static List<String> _findPath(String startNode, String endNode) {
    final queue = <List<String>>[
      [startNode]
    ];
    final visited = <String>{startNode};

    while (queue.isNotEmpty) {
      final currentPath = queue.removeAt(0);
      final currentNode = currentPath.last;

      if (currentNode == endNode) {
        return currentPath;
      }

      final neighbors = MapData.pathEdges[currentNode] ?? [];

      for (final neighbor in neighbors) {
        if (!visited.contains(neighbor)) {
          visited.add(neighbor);
          queue.add([...currentPath, neighbor]);
        }
      }
    }

    return [];
  }

  /// يجيب أقرب node في شبكة الممرات لنقطة معينة
  static String findNearestNode(LatLng point) {
    double minDistance = double.infinity;
    String nearestNodeId = '';

    MapData.pathNodes.forEach((id, node) {
      final dx = point.latitude - node.point.latitude;
      final dy = point.longitude - node.point.longitude;
      final distance = dx * dx + dy * dy;

      if (distance < minDistance) {
        minDistance = distance;
        nearestNodeId = id;
      }
    });

    return nearestNodeId;
  }

  /// يحسب المسافة التقريبية بين نقطتين
  static double _distance(LatLng a, LatLng b) {
    final dx = a.latitude - b.latitude;
    final dy = a.longitude - b.longitude;
    return dx * dx + dy * dy;
  }

  /// يجيب أقرب بوابة في الزون الهدف بالنسبة لليوزر
  /// سواء كانت entry أو exit
  static LatLng getClosestZonePoint({
    required ZoneData zone,
    required LatLng userLocation,
  }) {
    final entryDistance = _distance(userLocation, zone.entryPoint);
    final exitDistance = _distance(userLocation, zone.exitPoint);

    return entryDistance <= exitDistance ? zone.entryPoint : zone.exitPoint;
    
  }


  /// يجيب أقرب node للزون الهدف حسب أقرب بوابة
  static String getClosestZoneNodeId({
  required String zoneId,
  required LatLng userLocation,
}) {
  final startNodeId = findNearestNode(userLocation);
  if (startNodeId.isEmpty) return '';

  final entryNodeId = MapData.zoneEntryNodes[zoneId];
  final exitNodeId = MapData.zoneExitNodes[zoneId];

  if (entryNodeId == null || exitNodeId == null) return '';

  final entryPath = _findPath(startNodeId, entryNodeId);
  final exitPath = _findPath(startNodeId, exitNodeId);

  if (entryPath.isEmpty && exitPath.isEmpty) return '';
  if (entryPath.isEmpty) return exitNodeId;
  if (exitPath.isEmpty) return entryNodeId;

  return entryPath.length <= exitPath.length ? entryNodeId : exitNodeId;
}

  /// يجيب المسار من موقع المستخدم إلى أقرب بوابة في الزون الهدف
  static List<LatLng> getRouteToZone({
    required String toZoneId,
  }) {
    final toZone = MapData.zones[toZoneId];

    if (toZone == null) {
      return [];
    }

    final userLocation = MapData.mockUserLocation;

    final startNodeId = findNearestNode(userLocation);
    final endNodeId = getClosestZoneNodeId(
      zoneId: toZoneId,
      userLocation: userLocation,
    );

    if (startNodeId.isEmpty || endNodeId.isEmpty) {
      return [];
    }

    final nodePath = _findPath(startNodeId, endNodeId);

    if (nodePath.isEmpty) {
      return [];
    }

    final routePoints = <LatLng>[];

    // يبدأ من موقع المستخدم
    routePoints.add(userLocation);

    // يمر على شبكة الممرات
    for (final nodeId in nodePath) {
      final node = MapData.pathNodes[nodeId];
      if (node != null) {
        routePoints.add(node.point);
      }
    }
    final zoneCenter = MapData.zoneLabelCenters[toZoneId];
if (zoneCenter != null) {
  routePoints.add(zoneCenter);
}
    return routePoints;
  }

  /// يبني Polyline جاهزة للرسم من موقع المستخدم إلى أقرب بوابة في الزون الهدف
  static Polyline buildRouteToZonePolyline({
    required String toZoneId,
  }) {
    final points = getRouteToZone(toZoneId: toZoneId);

    return Polyline(
      polylineId: PolylineId('route_to_$toZoneId'),
      points: points,
      color: const Color(0xFF2F80ED),
      width: 5,
    );
  }

  /// ماركر للوجهة على أقرب بوابة
  static Marker buildDestinationMarker(String zoneId) {
    final zone = MapData.zones[zoneId];

    if (zone == null) {
      return const Marker(
        markerId: MarkerId('invalid_destination'),
        position: MapData.mockUserLocation,
        infoWindow: InfoWindow(title: 'Invalid destination'),
      );
    }

    final userLocation = MapData.mockUserLocation;

final closestNodeId = getClosestZoneNodeId(
  zoneId: zoneId,
  userLocation: userLocation,
);

final node = MapData.pathNodes[closestNodeId];


    return Marker(
      markerId: MarkerId('destination_$zoneId'),
      position: MapData.zoneLabelCenters[zoneId] ?? node!.point,
      infoWindow: InfoWindow(title: zone.name),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }

  /// ماركر اختياري لموقع المستخدم التجريبي
  static Marker buildMockUserMarker() {
    return const Marker(
      markerId: MarkerId('mock_user'),
      position: MapData.mockUserLocation,
      infoWindow: InfoWindow(title: 'Mock User'),
    );
  }
}