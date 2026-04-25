import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'zonePoint.dart';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class TestAreaPage extends StatefulWidget {
  final void Function(LatLng point, String zoneId)? onLocationSelected;

  const TestAreaPage({super.key, this.onLocationSelected});

  @override
  State<TestAreaPage> createState() => _TestAreaPageState();
}

class _TestAreaPageState extends State<TestAreaPage> {
  GoogleMapController? mapController;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _zonesSub;
  String selectedZoneId = '';

  Map<String, String> zoneLevels = {
    'zone_00A': 'low',
    'zone_00B': 'low',
    'zone_00C': 'low',
    'hall': 'low',
  };

  Map<String, int> zoneCounts = {'zone_00A': 0, 'zone_00B': 0, 'zone_00C': 0};

  static const LatLng center = LatLng(24.8260231, 46.6636767);

  ZonePoint? currentLocation;

  final Set<Circle> circles = {};
  Set<Polygon> polygons = {};
  final Set<Marker> labels = {};

  final Set<Polyline> borders = {
    Polyline(
      polylineId: const PolylineId('open_c'),
      points: const [
        LatLng(24.8261475234813, 46.66429225355387),
        LatLng(24.826053192954404, 46.66449744254351),
      ],
      color: Colors.grey,
      width: 3,
    ),
    Polyline(
      polylineId: const PolylineId('open_c_b'),
      points: const [
        LatLng(24.826882081964925, 46.663572415709496),
        LatLng(24.82667729455722, 46.66369680315256),
      ],
      color: Colors.grey,
      width: 3,
    ),
    Polyline(
      polylineId: const PolylineId('open_b_a'),
      points: const [
        LatLng(24.82592204297343, 46.66284419596195),
        LatLng(24.826034631132604, 46.663141921162605),
      ],
      color: Colors.grey,
      width: 3,
    ),
    Polyline(
      polylineId: const PolylineId('open_a'),
      points: const [
        LatLng(24.825475949423183, 46.66411589831114),
        LatLng(24.825177132790394, 46.66418798267841),
      ],
      color: Colors.grey,
      width: 3,
    ),
    Polyline(
      polylineId: const PolylineId('open_hall'),
      points: const [
        LatLng(24.825541676813902, 46.66481528431177),
        LatLng(24.825336887189867, 46.66472274810076),
      ],
      color: Colors.black,
      width: 6,
    ),
  };

  Color _zoneFillColor(String zoneId, Color defaultColor) {
    final level = zoneLevels[zoneId] ?? 'low';

    switch (level) {
      case 'high':
        return Colors.red.withOpacity(0.3);
      case 'medium':
        return Colors.orange.withOpacity(0.3);
      case 'low':
      default:
        return Colors.green.withOpacity(0.3);
    }
  }

  void _listenToZones() {
    _zonesSub = _firestore.collection('zones').snapshots().listen((snapshot) {
      final updatedLevels = <String, String>{};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        updatedLevels[doc.id] = (data['congestionLevel'] ?? 'low').toString();
        zoneCounts[doc.id] = ((data['currentCount'] ?? 0) as num).toInt();
      }

      if (!mounted) return;

      setState(() {
        zoneLevels = {...zoneLevels, ...updatedLevels};
        _buildPolygons();
        labels.clear();
      });

      _loadLabels();
    });
  }

  void _buildPolygons() {
    polygons = {
      Polygon(
        polygonId: const PolygonId('hall'),
        points: const [
          LatLng(24.82449764177584, 46.66430063545704),
          LatLng(24.825253206339646, 46.6641591489315),
          LatLng(24.826268023017608, 46.663974076509476),
          LatLng(24.82607145048134, 46.664384454488754),
          LatLng(24.825859054418114, 46.664907820522785),
          LatLng(24.825234644397927, 46.66468217968941),
        ],
        fillColor: Colors.transparent,
        strokeWidth: 0,
        consumeTapEvents: true,
        onTap: () {
          handleZoneTap(ZonePoint.hall);
        },
      ),
      Polygon(
        polygonId: const PolygonId('main_boundary'),
        points: const [
          LatLng(24.8276583, 46.6648039),
          LatLng(24.8276422, 46.6648512),
          LatLng(24.8269974, 46.6651838),
          LatLng(24.8267628, 46.6652454),
          LatLng(24.8265051, 46.6652263),
          LatLng(24.8261868, 46.6650872),
          LatLng(24.8248080, 46.6645497),
          LatLng(24.8245016, 46.6643519),
          LatLng(24.8242859, 46.6640985),
          LatLng(24.8239940, 46.6634118),
          LatLng(24.8240427, 46.6632834),
          LatLng(24.8264287, 46.6620841),
          LatLng(24.8265251, 46.662100),
          LatLng(24.8270284, 46.6633498),
          LatLng(24.8276008, 46.6647097),
        ],
        fillColor: const Color(0xFF9E9E9E).withOpacity(0.15),
        strokeColor: const Color(0xFF424242),
        strokeWidth: 3,
      ),
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
        fillColor: _zoneFillColor('zone_00C', const Color(0x44EF5350)),
        strokeWidth: 0,
        consumeTapEvents: true,
        onTap: () {
          handleZoneTap(ZonePoint.c);
        },
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
        fillColor: _zoneFillColor('zone_00B', const Color(0x4456C271)),
        strokeWidth: 0,
        consumeTapEvents: true,
        onTap: () {
          handleZoneTap(ZonePoint.b);
        },
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
        fillColor: _zoneFillColor('zone_00A', const Color(0x445AA9FF)),
        strokeWidth: 0,
        consumeTapEvents: true,
        onTap: () {
          handleZoneTap(ZonePoint.a);
        },
      ),
    };
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

  void _loadLabels() async {
    final a = await _createTextMarker("Zone A\n${zoneCounts['zone_00A'] ?? 0}");
    final b = await _createTextMarker("Zone B\n${zoneCounts['zone_00B'] ?? 0}");
    final c = await _createTextMarker("Zone C\n${zoneCounts['zone_00C'] ?? 0}");

    if (!mounted) return;

    setState(() {
      labels.add(
        Marker(
          markerId: const MarkerId("A"),
          position: _zoneCenter(ZonePoint.a),
          icon: a,
        ),
      );

      labels.add(
        Marker(
          markerId: const MarkerId("B"),
          position: _zoneCenter(ZonePoint.b),
          icon: b,
        ),
      );

      labels.add(
        Marker(
          markerId: const MarkerId("C"),
          position: _zoneCenter(ZonePoint.c),
          icon: c,
        ),
      );
    });
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

  String _zoneId(ZonePoint zone) {
    switch (zone) {
      case ZonePoint.a:
        return "zone_00A";
      case ZonePoint.b:
        return "zone_00B";
      case ZonePoint.c:
        return "zone_00C";
      case ZonePoint.hall:
        return "hall";
    }
  }

  void _resetSelection() {
    setState(() {
      currentLocation = null;
      circles.clear();
    });

    widget.onLocationSelected?.call(center, "");
  }

  void handleZoneTap(ZonePoint zone) {
    if (currentLocation == null) {
      setState(() {
        currentLocation = zone;
        selectedZoneId = _zoneId(zone);
        circles.clear();

        circles.add(
          Circle(
            circleId: const CircleId('current_location'),
            center: _zoneCenter(zone),
            radius: 10,
            fillColor: Colors.blue.withOpacity(0.4),
            strokeColor: Colors.blue,
            strokeWidth: 2,
          ),
        );
      });

      widget.onLocationSelected?.call(_zoneCenter(zone), _zoneId(zone));
      return;
    }

    if (zone == currentLocation) {
      _resetSelection();
      widget.onLocationSelected?.call(center, "");
      return;
    }

    setState(() {
      currentLocation = zone;
      selectedZoneId = _zoneId(zone);
      circles.clear();

      circles.add(
        Circle(
          circleId: const CircleId('current_location'),
          center: _zoneCenter(zone),
          radius: 10,
          fillColor: Colors.blue.withOpacity(0.4),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        ),
      );
    });

    widget.onLocationSelected?.call(_zoneCenter(zone), _zoneId(zone));
  }

  @override
  void initState() {
    super.initState();
    _buildPolygons();
    _loadLabels();
    _listenToZones();
  }

  @override
  void dispose() {
    _zonesSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: center,
            zoom: 16.2,
          ),
          mapType: MapType.satellite,
          onTap: (LatLng point) {
            debugPrint('LatLng(${point.latitude}, ${point.longitude})');
          },
          polygons: polygons,
          polylines: borders,
          markers: labels,
          circles: circles,
          onMapCreated: (controller) {
            mapController = controller;
          },
        ),
      ],
    );
  }
}
