import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RiyadhSeasonMapView extends StatefulWidget {
  const RiyadhSeasonMapView({super.key});

  @override
  State<RiyadhSeasonMapView> createState() => _RiyadhSeasonMapViewState();
}

class _RiyadhSeasonMapViewState extends State<RiyadhSeasonMapView> {
  GoogleMapController? _mapController;

  static const LatLng _initialCenter = LatLng(24.7779831, 46.6089090);

  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};

  String _mapStyle = '''
[
  {
    "featureType": "poi",
    "stylers": [
      { "visibility": "off" }
    ]
  }
]
''';

  @override
  void initState() {
    super.initState();
    _buildZones();
    _loadTextMarkers();
    _addFixedBoulevardWorldMarker();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController!.setMapStyle(_mapStyle);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _buildZones() {
    _polygons.addAll({
      Polygon(
        polygonId: const PolygonId('boulevard_world'),
        points: const [
          LatLng(24.781700764468926, 46.60266883671284),
          LatLng(24.778887762792493, 46.59633010625839),
          LatLng(24.77122405693622, 46.59873638302088),
          LatLng(24.774423540423815, 46.60628244280815),
        ],
        strokeWidth: 0,
        fillColor: ui.Color.fromARGB(120, 251, 92, 92),
      ),
      Polygon(
        polygonId: const PolygonId('boulevard_city'),
        points: const [
          LatLng(24.77427833254074, 46.60635385662317),
          LatLng(24.771083716144016, 46.59884735941887),
          LatLng(24.76271321221035, 46.60318650305271),
          LatLng(24.76595979869612, 46.6107214987278),
        ],
        strokeWidth: 0,
        fillColor: Color.fromARGB(120, 170, 220, 170),
      ),

      // Al-Bujairi
      Polygon(
        polygonId: const PolygonId('al_bujairi'),
        points: const [
          
          LatLng(24.778655803743533, 46.61676451563835),
          LatLng(24.782718068497896, 46.6262960806489),
          LatLng(24.774376051071933, 46.63046456873417),
          LatLng(24.77044259111477, 46.62096653133631),
        ],
        strokeWidth: 0,
        fillColor: Color.fromARGB(120, 255, 220, 120),
      ),

      // Riyadh Zoo
      Polygon(
        polygonId: const PolygonId('riyadh_zoo'),
        points: const [
             
          LatLng(24.794806971239044, 46.608077846467495),
          LatLng(24.791882865113543, 46.60176727920771),
          LatLng(24.78971903699114,46.60088483244181),
          LatLng(24.783648611289692,46.603893265128136),
          LatLng(24.78694243927557, 46.61204919219017),
        ],
        strokeWidth: 0,
        fillColor: Color.fromARGB(90, 170, 220, 170),
      ),
    });
  }

  Future<void> _loadTextMarkers() async {
    final newMarkers = <Marker>{};

    final places = {
      'boulevard_world': {
        'text': 'Boulevard\nWorld',
        'position': const LatLng(24.776548061496634, 46.601013243198395),
      },
      'boulevard_city': {
        'text': 'Boulevard\nCity',
        'position': const LatLng(24.769072350312786, 46.60460975021124),
      },
      'al_bujairi': {
        'text': 'Al-Bujairi',
        'position': const LatLng(24.776870130724998, 46.623679921031), 
      },
      'riyadh_zoo': {
        'text': 'Riyadh\nZoo',
        'position': const LatLng(24.7914674,46.6070050), 
      },
    };

    for (final entry in places.entries) {
      final marker = await _createTextMarker(
        id: '${entry.key}_label',
        text: entry.value['text'] as String,
        position: entry.value['position'] as LatLng,
      );
      newMarkers.add(marker);
    }

    if (!mounted) return;

    setState(() {
      _markers.addAll(newMarkers);
    });
  }

  void _addFixedBoulevardWorldMarker() {
    const boulevardWorldMarkerPosition = LatLng(24.777467996150943, 46.60048417747021);

    _markers.add(const Marker(
        markerId: MarkerId('boulevard_world_fixed_marker'),
        position: boulevardWorldMarkerPosition,
        infoWindow: InfoWindow(title: 'Boulevard World'),
      ),
    );
  }

  Future<Marker> _createTextMarker({
    required String id,
    required String text,
    required LatLng position,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    const textStyle = TextStyle(
      color: ui.Color.fromARGB(255, 43, 43, 43),
      fontSize: 28,
      fontWeight: FontWeight.w600,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(canvas, const Offset(0, 0));

    final image = await recorder.endRecording().toImage(
      textPainter.width.ceil(),
      textPainter.height.ceil(),
    );

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to create text marker');
    }

    final bytes = byteData.buffer.asUint8List();

    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: BitmapDescriptor.fromBytes(bytes),
      anchor: const Offset(0.5, 0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: _initialCenter,
        zoom: 14.4,
      ),
      mapType: MapType.normal,
      polygons: _polygons,
      markers: _markers,
      onTap: (LatLng point) {
        print('Lat: ${point.latitude}, Lng: ${point.longitude}');
      },
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: false,
      zoomControlsEnabled: true,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      minMaxZoomPreference: const MinMaxZoomPreference(13, 19),
    );
  }
}