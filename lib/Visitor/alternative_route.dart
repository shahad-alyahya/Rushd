import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rushd/map/map_view.dart';
import 'package:rushd/map/routePath.dart';
import 'package:rushd/map/zonePoint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
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

class _TestAreaAlternativeMap extends StatefulWidget {
  final LatLng userLocation;
  final String destinationZoneId;
  final String startZoneId;

  const _TestAreaAlternativeMap({
    required this.userLocation,
    required this.destinationZoneId,
    required this.startZoneId,
  });

  @override
  State<_TestAreaAlternativeMap> createState() =>
      _TestAreaAlternativeMapState();
}

class _TestAreaAlternativeMapState extends State<_TestAreaAlternativeMap> {
  static const LatLng center = LatLng(24.8260231, 46.6636767);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _zonesSub;

  Map<String, String> zoneLevels = {
    'zone_00A': 'low',
    'zone_00B': 'low',
    'zone_00C': 'low',
  };

  Map<String, int> zoneCounts = {
    'zone_00A': 0,
    'zone_00B': 0,
    'zone_00C': 0,
  };

  @override
  void initState() {
    super.initState();
    _listenToZones();
  }

  @override
  void dispose() {
    _zonesSub?.cancel();
    super.dispose();
  }
// Listens to Firestore zone updates.
  void _listenToZones() {
    _zonesSub = _firestore
        .collection('zones')
        .where('locationId', isEqualTo: 'test_area_001')
        .snapshots()
        .listen((snapshot) {
      final updatedLevels = <String, String>{};
      final updatedCounts = <String, int>{};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        updatedLevels[doc.id] =
            (data['congestionLevel'] ?? 'low').toString();
        updatedCounts[doc.id] =
            ((data['currentCount'] ?? 0) as num).toInt();
      }

      if (!mounted) return;

      setState(() {
        zoneLevels = {...zoneLevels, ...updatedLevels};
        zoneCounts = {...zoneCounts, ...updatedCounts};
      });
    });
  }

  Color _zoneFillColor(String zoneId) {
    final level = zoneLevels[zoneId] ?? 'low';

    if (level == 'high') return Colors.red.withOpacity(0.3);
    if (level == 'medium') return Colors.orange.withOpacity(0.3);
    return Colors.green.withOpacity(0.3);
  }

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
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      textPainter.width.toInt(),
      textPainter.height.toInt(),
    );

    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Future<Set<Marker>> _zoneLabels() async {
    final a =
        await _createTextMarker("Zone A\n${zoneCounts['zone_00A'] ?? 0}");
    final b =
        await _createTextMarker("Zone B\n${zoneCounts['zone_00B'] ?? 0}");
    final c =
        await _createTextMarker("Zone C\n${zoneCounts['zone_00C'] ?? 0}");

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

  ZonePoint _zoneFromId(String zoneId) {
    switch (zoneId.toLowerCase()) {
      case 'a':
      case 'zone_a':
      case 'zone_00a':
        return ZonePoint.a;
      case 'b':
      case 'zone_b':
      case 'zone_00b':
        return ZonePoint.b;
      case 'c':
      case 'zone_c':
      case 'zone_00c':
        return ZonePoint.c;
      case 'hall':
        return ZonePoint.hall;
      default:
        return ZonePoint.a;
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
// Creates zone polygons.
  Set<Polygon> _polygons() {
    return {
      Polygon(
        polygonId: const PolygonId('zoneC'),
        points: const [
          LatLng(24.827674146566494, 46.66478343307972),
          LatLng(24.827655584987614, 46.6648240049107),
          LatLng(24.827013230929264, 46.66515324264765),
          LatLng(24.826779536158234, 46.66521392762661),
          LatLng(24.82653823367279, 46.66520554572344),
          LatLng(24.825838058225894, 46.66491620242596),
          LatLng(24.82629449638488, 46.66394256055355),
          LatLng(24.82708656474439, 46.66345104575157),
          LatLng(24.827422195717485, 46.664228551089764),
        ],
        fillColor: _zoneFillColor('zone_00C'),
        strokeWidth: 0,
      ),
      Polygon(
        polygonId: const PolygonId('zoneB'),
        points: const [
          LatLng(24.82711547225293, 46.66345976293087),
          LatLng(24.826564706982303, 46.66207540780306),
          LatLng(24.82647281110203, 46.66204355657101),
          LatLng(24.825709342360998, 46.662453934550285),
          LatLng(24.826312753876245, 46.66392210870981),
        ],
        fillColor: _zoneFillColor('zone_00B'),
        strokeWidth: 0,
      ),
      Polygon(
        polygonId: const PolygonId('zoneA'),
        points: const [
          LatLng(24.826341661565415, 46.66392210870981),
          LatLng(24.825735815847683, 46.662433817982674),
          LatLng(24.82408045131227, 46.66325457394123),
          LatLng(24.824041196995015, 46.66338734328747),
          LatLng(24.82432175858615, 46.66407532989979),
          LatLng(24.82449764177584, 46.66429225355387),
          LatLng(24.82456306538995, 46.66436433792114),
          LatLng(24.826341661565415, 46.66392210870981),
        ],
        fillColor: _zoneFillColor('zone_00A'),
        strokeWidth: 0,
      ),
    };
  }
// Creates the route path.
  Set<Polyline> _routeLine() {
    final route = getRoute(
      _zoneFromId(widget.startZoneId),
      _zoneFromId(widget.destinationZoneId),
    );

    if (route == null) return {};

    return {
      Polyline(
        polylineId: const PolylineId('selected_route'),
        points: route.points,
        color: Colors.blue,
        width: 8,
      ),
    };
  }

  Set<Circle> _currentCircle() {
    final route = getRoute(
      _zoneFromId(widget.startZoneId),
      _zoneFromId(widget.destinationZoneId),
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
      _zoneFromId(widget.startZoneId),
      _zoneFromId(widget.destinationZoneId),
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
// Builds the alternative route screen.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Set<Marker>>(
      future: _zoneLabels(),
      builder: (context, snapshot) {
        final labels = snapshot.data ?? {};
// Builds the Google Map.
        return GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: center,
            zoom: 16.2,
          ),
          mapType: MapType.satellite,
          polygons: _polygons(),
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