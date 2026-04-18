import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rushd/map/map_view.dart';
import 'package:rushd/map/routePath.dart';
import 'package:rushd/map/zonePoint.dart';
import 'dart:ui' as ui;

class AlternativeRoute extends StatefulWidget {
  final String zoneName;
  final String locationName;
  final String distance;
  final String estimatedTime;
  final String zoneId;
  final String startZoneId;
  final LatLng userLocation;

  const AlternativeRoute({
    super.key,
    required this.zoneName,
    required this.locationName,
    required this.distance,
    required this.estimatedTime,
    required this.zoneId,
    required this.startZoneId,
    required this.userLocation,
  });

  @override
  State<AlternativeRoute> createState() => _AlternativeRouteState();
}

class _AlternativeRouteState extends State<AlternativeRoute> {
  
  static const Color kPurple = Color(0xFF867AB9);
  static const Color kDark = Color(0xFF353841);

  DateTime _lastUpdate = DateTime.now();

  void _refresh() {
    setState(() {
      _lastUpdate = DateTime.now();
    });
  }

  String _formattedTime(DateTime dateTime) {
    final hh = dateTime.hour.toString().padLeft(2, '0');
    final mm = dateTime.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final bool isTestArea = widget.locationName == "Test Area";

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 26,
                                color: kPurple,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.locationName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _refresh,
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text("Refresh"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kDark,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(0, 28),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 0,
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Last update: ${_formattedTime(_lastUpdate)}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(0),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: isTestArea
                              ? _TestAreaAlternativeMap(
                                  userLocation: widget.userLocation,
                                  destinationZoneId: widget.zoneId,
                                  startZoneId: widget.startZoneId,
                                )
                              : MapView(
                                  mode: MapMode.navigation,
                                  initialUserLocation: widget.userLocation,
                                  destinationZoneId: widget.zoneId,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(42),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 90,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0x80B2B2B2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                widget.zoneName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      widget.locationName,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.directions_walk, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Distance: ${widget.distance}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Estimated time: ${widget.estimatedTime}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 163,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF8A8A),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "exit",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TestAreaAlternativeMap extends StatelessWidget {
  final LatLng userLocation;
  final String destinationZoneId;
  final String startZoneId;

  const _TestAreaAlternativeMap({
    required this.userLocation,
    required this.destinationZoneId,
    required this.startZoneId,
  });

  static const LatLng center = LatLng(24.8260231, 46.6636767);

  // ================= TEXT MARKER =================
  Future<BitmapDescriptor> _createTextMarker(String text) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 35,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      textPainter.width.toInt(),
      textPainter.height.toInt(),
    );

    final bytes =
        await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Future<Set<Marker>> _zoneLabels() async {
    final a = await _createTextMarker("Zone A");
    final b = await _createTextMarker("Zone B");
    final c = await _createTextMarker("Zone C");

    return {
      Marker(
        markerId: const MarkerId("A_label"),
        position: _zoneCenter(ZonePoint.a),
        icon: a,
      ),
      Marker(
        markerId: const MarkerId("B_label"),
        position: _zoneCenter(ZonePoint.b),
        icon: b,
      ),
      Marker(
        markerId: const MarkerId("C_label"),
        position: _zoneCenter(ZonePoint.c),
        icon: c,
      ),
    };
  }

  // ================= ZONE =================
  ZonePoint _zoneFromId(String zoneId) {
    switch (zoneId.toLowerCase()) {
      case 'a':
      case 'zone_a':
        return ZonePoint.a;
      case 'b':
      case 'zone_b':
        return ZonePoint.b;
      case 'c':
      case 'zone_c':
        return ZonePoint.c;
      case 'hall':
        return ZonePoint.hall;
      default:
        return ZonePoint.c;
    }
  }

  LatLng _zoneCenter(ZonePoint zone) {
    switch (zone) {
      case ZonePoint.a:
        return const LatLng(24.82545, 46.66335);
      case ZonePoint.b:
        return const LatLng(24.82630, 46.66305);
      case ZonePoint.c:
        return const LatLng(24.82692, 46.66435);
      case ZonePoint.hall:
        return const LatLng(24.82535, 46.66445);
    }
  }

  // ================= POLYGONS =================
  Set<Polygon> _polygons() {
    return {
      Polygon(
        polygonId: const PolygonId('zoneC'),
        points: const [
          LatLng(24.8276741, 46.6647834),
          LatLng(24.8270132, 46.6651532),
          LatLng(24.8265382, 46.6652055),
          LatLng(24.8258380, 46.6649162),
          LatLng(24.8262944, 46.6639425),
          LatLng(24.8270865, 46.6634510),
        ],
        fillColor: const Color(0x44EF5350),
        strokeWidth: 0,
      ),
      Polygon(
        polygonId: const PolygonId('zoneB'),
        points: const [
          LatLng(24.8271154, 46.6634597),
          LatLng(24.8265647, 46.6620754),
          LatLng(24.8257093, 46.6624539),
          LatLng(24.8263127, 46.6639221),
        ],
        fillColor: const Color(0x4456C271),
        strokeWidth: 0,
      ),
      Polygon(
        polygonId: const PolygonId('zoneA'),
        points: const [
          LatLng(24.8263416, 46.6639221),
          LatLng(24.8257358, 46.6624338),
          LatLng(24.8240804, 46.6632545),
          LatLng(24.8243217, 46.6640753),
          LatLng(24.8244976, 46.6642922),
        ],
        fillColor: const Color(0x445AA9FF),
        strokeWidth: 0,
      ),
    };
  }

  // ================= ROUTE =================
  Set<Polyline> _routeLine() {
    final route = getRoute(
      _zoneFromId(startZoneId),
      _zoneFromId(destinationZoneId),
    );

    if (route == null) return {};

    return {
      Polyline(
        polylineId: const PolylineId('selected_route'),
        points: route.points,
        color: Colors.deepPurple,
        width: 8,
      ),
    };
  }

  Set<Circle> _currentCircle() {
    final route = getRoute(
      _zoneFromId(startZoneId),
      _zoneFromId(destinationZoneId),
    );

    if (route == null || route.points.isEmpty) return {};

    return {
      Circle(
        circleId: const CircleId('current_location'),
        center: route.points.first,
        radius: 12,
        fillColor: Colors.blue.withOpacity(0.4),
        strokeColor: Colors.blue,
        strokeWidth: 1,
      ),
    };
  }

  Set<Marker> _destinationMarker() {
    final route = getRoute(
      _zoneFromId(startZoneId),
      _zoneFromId(destinationZoneId),
    );

    if (route == null || route.points.isEmpty) return {};

    return {
      Marker(
        markerId: const MarkerId('destination'),
        position: route.points.last,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      ),
    };
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Set<Marker>>(
      future: _zoneLabels(),
      builder: (context, snapshot) {
        final labels = snapshot.data ?? {};

        return GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: center,
            zoom: 16.2,
          ),
          mapType: MapType.satellite,
          polygons: _polygons(), // 👈 رجعناها
          polylines: _routeLine(),
          circles: _currentCircle(),
          markers: {
            ..._destinationMarker(),
            ...labels,
          },
          zoomControlsEnabled: false,
        );
      },
    );
  }
}