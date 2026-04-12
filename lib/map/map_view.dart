import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_data.dart';
import 'route_service.dart';
import 'zone_logic.dart';
import 'location_service.dart';
import 'dart:ui' as ui;


class MapView extends StatefulWidget {
  
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;

Set<Polyline> _polylines = {};
Set<Circle> _circles = {};
LatLng? _selectedUserLocation;

  // مركز تقريبي داخل منطقة البوليفارد
  static const LatLng _boulevardWorldCenter = MapData.boulevardWorldCenter;

  // نحصر الحركة داخل مساحة صغيرة فقط
  static final CameraTargetBounds _boulevardBounds = MapData.boulevardBounds;

  final Set<Marker> _markers = {};

 
 
    @override
void initState() {

  super.initState();
   _circles = {};
 // _circles = Location Service.getUserLocationCircles();
  _loadZoneLabels();

_polylines = {};
  //_polylines = {
  // RouteService.buildRouteToZonePolyline(
  //  userLocation: point,
   //  toZoneId: 'japan',
  //),
 // };
 // _setDestinationMarker('japan');
}

LatLng _snapToNearestZoneCenter(LatLng point) {
  double minDistance = double.infinity;
  LatLng nearestPoint = point;

  for (final center in MapData.zoneLabelCenters.values) {
    final dx = point.latitude - center.latitude;
    final dy = point.longitude - center.longitude;
    final distance = dx * dx + dy * dy;

    if (distance < minDistance) {
      minDistance = distance;
      nearestPoint = center;
    }
  }

  return nearestPoint;
}
Future<void> _loadZoneLabels() async {
  final newMarkers = <Marker>{};

  for (final entry in MapData.zoneLabelCenters.entries) {
    final zoneId = entry.key;
    final center = entry.value;
    final text = MapData.zoneLabelTexts[zoneId];

    if (text == null) continue;

    final marker = await _createTextMarker(
      id: '${zoneId}_label',
      text: text,
      position: center,
    );

    newMarkers.add(marker);
  }

  setState(() {
    _markers.addAll(newMarkers);
  });
}

void _setDestinationMarker(String zoneId, LatLng userLocation) {
  final destinationMarker =
      RouteService.buildDestinationMarker(zoneId, userLocation);

  setState(() {
    _markers.removeWhere((m) => m.markerId.value.startsWith('destination_'));
    _markers.add(destinationMarker);
  });
}
  void _onMapCreated(GoogleMapController controller) {
  _mapController = controller;

}

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
 static List<LatLng> zoneShape(double lat, double lng) {
  return [
    LatLng(lat + 0.00072, lng),
    LatLng(lat + 0.00038, lng + 0.00058),
    LatLng(lat + 0.00008, lng + 0.00054),
    LatLng(lat - 0.00034, lng + 0.00024),
    LatLng(lat - 0.00046, lng - 0.00028),
    LatLng(lat - 0.00010, lng - 0.00060),
    LatLng(lat + 0.00036, lng - 0.00052),
    LatLng(lat + 0.00056, lng - 0.00014),
  ];
}
 
 
 final Set<Polygon> _polygons = {
  
  

  // 1 - أعلى يسار
  Polygon(
    polygonId: PolygonId('saudia'),
    points: [
      LatLng(24.7741334, 46.6003457),
      LatLng(24.7741490, 46.6009690),
      LatLng(24.7740488, 46.6014571),
      LatLng(24.7736792, 46.6014431),
      LatLng(24.7734232, 46.6010595),
      LatLng(24.7732774, 46.6007601),
      LatLng(24.7733514, 46.6004597),
      LatLng(24.7734537, 46.6000892),
      LatLng(24.7736576, 46.5999799),
      LatLng(24.7738016, 46.6001053),
      LatLng(24.7740107, 46.6001681),
      LatLng(24.7741435, 46.6002123),
    ],
    strokeWidth: 0,
   fillColor: ZoneLogic.getZoneColorById('saudia'),
  ),

  // 2 - أعلى وسط يسار
  Polygon(
    polygonId: PolygonId('china'),
    points: [
      LatLng(24.7741815, 46.6008265),
      LatLng(24.7741389, 46.6011068),
      LatLng(24.7741146, 46.6014820),
      LatLng(24.7741773, 46.6016697),
      LatLng(24.7744129, 46.6017529),
      LatLng(24.7747200, 46.6016308),
      LatLng(24.7747624, 46.6015846),
      LatLng(24.7748595, 46.6015862),
      LatLng(24.7750032, 46.6015554),
      LatLng(24.7751435, 46.6014934),
      LatLng(24.7752793, 46.6014350),
      LatLng(24.7753140, 46.6013666),
      LatLng(24.7753380, 46.6011836),
      LatLng(24.7753590, 46.6009113),
      LatLng(24.7753356, 46.6008694),
      LatLng(24.7753003, 46.6008577),
      LatLng(24.7750156, 46.6008315),
      LatLng(24.7748790, 46.6008520),
      LatLng(24.7747730, 46.6009046),
      LatLng(24.7741864, 46.6008060),
    ],
    strokeWidth: 0,
    fillColor: ZoneLogic.getZoneColorById('china'),
  ),

  // 3 - أعلى وسط
  Polygon(
    polygonId: PolygonId('sham'),
    points: [
      LatLng(24.7745368, 46.6023108),
      LatLng(24.7742488, 46.6017327),
      LatLng(24.7736025, 46.6020523),
      LatLng(24.7738269, 46.6026491),
      LatLng(24.7738193, 46.6027057),
      

    ],
    strokeWidth: 0,
         fillColor: ZoneLogic.getZoneColorById('sham'),

  ),

  // 4 - أعلى يمين
  Polygon(
    polygonId: PolygonId('moroco'),
    points: [
      LatLng(24.7744826, 46.6028687),
      LatLng(24.7751298, 46.6031161),
      LatLng(24.7754449, 46.6030075),
      LatLng(24.7754467, 46.6028697),
      LatLng(24.7756461, 46.6025096),
      LatLng(24.7755328, 46.6023161),
      LatLng(24.7752327, 46.6018776),
      LatLng(24.7749462, 46.6018514),
      LatLng(24.7748936, 46.6017730),
      LatLng(24.7748047, 46.6018410),
      LatLng(24.7748074, 46.6018900),
      LatLng(24.7747228, 46.6019530),
      
      LatLng(24.7745009, 46.6028348),
    ],
    strokeWidth: 0,
     fillColor: ZoneLogic.getZoneColorById('moroco'),
  ),

  // 5 - يمين أعلى
  Polygon(
    polygonId: PolygonId('italy'),
    points: [
      LatLng(24.7757164, 46.6021381),
      LatLng(24.7761593, 46.6026427),
      LatLng(24.7763152, 46.6026990),
      LatLng(24.7765691, 46.6024908),
      LatLng(24.7767639, 46.6019691),
      LatLng(24.7765012, 46.6014907),
      LatLng(24.7761861, 46.6015091),
      LatLng(24.7760397, 46.6015343),
      LatLng(24.7759998, 46.6015088),
      LatLng(24.7758561, 46.6016305),
      LatLng(24.7759085, 46.6016918),
      LatLng(24.7757021, 46.6020935),
      

    ],
    strokeWidth: 0,
     fillColor: ZoneLogic.getZoneColorById('italy'),
  ),

  // 6 - يمين وسط
  Polygon(
    polygonId: PolygonId('kuwait'),
    points: [
      LatLng(24.7748354, 46.6032415),
      LatLng(24.7745639, 46.6039848),
      LatLng(24.7744951, 46.6040354),
      LatLng(24.7747709, 46.6045819),
      LatLng(24.7757118, 46.6050141),
      LatLng(24.7761207, 46.6037816),
      LatLng(24.7758269, 46.6035724),
      LatLng(24.7753091, 46.6033719),
      LatLng(24.7748838, 46.6032542),
    ],
    strokeWidth: 0,
    fillColor: ZoneLogic.getZoneColorById('kuwait'),
  ),

  // 7 - يمين أسفل
  Polygon(
    polygonId: PolygonId('greece'),
    points: [
      LatLng(24.7771100, 46.6035469),
      LatLng(24.7771624, 46.6029749),
      LatLng(24.7763858, 46.6028599),
      LatLng(24.7761578, 46.6032552),
      LatLng(24.7763030, 46.6034068),
      LatLng(24.7770936, 46.6035184),
    ],
    strokeWidth: 0,
 fillColor: ZoneLogic.getZoneColorById('greece'), 
  ),

  // 8 - أسفل يمين
  Polygon(
    polygonId: PolygonId('Egypt'),
    points: [
      LatLng(24.7771051, 46.6037481),
      LatLng(24.7775998, 46.6038212),
      LatLng(24.7778713, 46.6038289),
      LatLng(24.7783700, 46.6036140),
      LatLng(24.7785213, 46.6034940),
      LatLng(24.7786835, 46.6032385),
      LatLng(24.7785764, 46.6029029),
      LatLng(24.7782838, 46.6025703),
      LatLng(24.7779599, 46.6024693),
      LatLng(24.7776756, 46.6024392),
      LatLng(24.7771809, 46.6027771),
      LatLng(24.7771748, 46.6031992),
      LatLng(24.7770914, 46.6037105),
        
    ],
    strokeWidth: 0,
 fillColor: ZoneLogic.getZoneColorById('Egypt'),  ),

  // 9 - أسفل
  Polygon(
    polygonId: PolygonId('turky'),
    points: [
      LatLng(24.7786202, 46.6028469),
      LatLng(24.7789623, 46.6024164),
      LatLng(24.7791785, 46.6021300),
      LatLng(24.7793270, 46.6014035),
      LatLng(24.7793333, 46.6013220),
      LatLng(24.7792241, 46.6008909),
      LatLng(24.7791060, 46.6004470),
      LatLng(24.7789919, 46.6000949),
      LatLng(24.7784324, 46.6001791),
      LatLng(24.7783082, 46.6004550),
      LatLng(24.7782519, 46.6011276),
      LatLng(24.7780534, 46.6014337),
      LatLng(24.7778369, 46.6021904),
      LatLng(24.7782628, 46.6025438),
      LatLng(24.7785910, 46.6028650),
    ],
    strokeWidth: 0,
 fillColor: ZoneLogic.getZoneColorById('turky'),  ),

  // 10 - أسفل يسار
  Polygon(
    polygonId: PolygonId('Spain'),
    points: [
      LatLng(24.7776394, 46.6005372),
      LatLng(24.7784293, 46.6001449),
      LatLng(24.7784932, 46.6000191),
      LatLng(24.7786318, 46.5997771),
      LatLng(24.7782327, 46.5991313),
      LatLng(24.7774226, 46.5997539),
      LatLng(24.7775003, 46.6000570),
      LatLng(24.7776269, 46.6005123),
    ], 
    strokeWidth: 0,
 fillColor: ZoneLogic.getZoneColorById('Spain'),  ),

   Polygon(
    polygonId: PolygonId('US'),
    points: [
      LatLng(24.7777429, 46.5994244),
      LatLng(24.7784147, 46.5989087),
      LatLng(24.7779450, 46.5982063),
      LatLng(24.7774354, 46.5986465),
      LatLng(24.77733004, 46.5989339),
      LatLng(24.7777094, 46.5994089),

    
    ],
    strokeWidth: 0,
 fillColor: ZoneLogic.getZoneColorById('US'),  ),

  // 11 - يسار وسط
  Polygon(
    polygonId: PolygonId('japan'),
    points: [
      LatLng(24.7761459, 46.5986368),
      LatLng(24.7764826, 46.5984879),
      LatLng(24.7767286, 46.5987340),
      LatLng(24.7770680, 46.5987984),
      LatLng(24.7772312, 46.5988192),
      LatLng(24.7774029, 46.5985376),
      LatLng(24.7775033, 46.5983542),
      LatLng(24.7773581, 46.5981564),
      LatLng(24.7771633, 46.5980323),
      LatLng(24.7770022, 46.5979797),
      LatLng(24.7767082, 46.5980162),
      LatLng(24.7765134, 46.5980457),
      LatLng(24.7763572, 46.5976129),
      LatLng(24.7757535, 46.5978694),
      LatLng(24.7760875, 46.5986589),
        
    ],
    strokeWidth: 0,
 fillColor: ZoneLogic.getZoneColorById('japan'),  ),

  // 12 - يسار أعلى
  Polygon(
    polygonId: PolygonId('india'),
    points: [
      LatLng(24.7743937, 46.5996762),
      LatLng(24.7745767, 46.5995853),
      LatLng(24.7748488, 46.5996477),
      LatLng(24.7752041, 46.5999052),
      LatLng(24.7755286, 46.5999109),
      LatLng(24.7756138, 46.5999581),
      LatLng(24.7757694, 46.5998881),
      LatLng(24.7757913, 46.5998388),
      LatLng(24.7758126, 46.5996081),
      LatLng(24.7758415, 46.5994512),
      LatLng(24.7759590, 46.5993664),
      LatLng(24.7760777, 46.5992185),
      LatLng(24.7761225, 46.5990864),
      LatLng(24.7761231, 46.5989888),
      LatLng(24.7761405, 46.5987642),
      LatLng(24.7760689, 46.5984960),
      LatLng(24.7759167, 46.5981500),
      LatLng(24.7757036, 46.5976796),
      LatLng(24.7748646, 46.5980642),
      LatLng(24.7743700, 46.5984055),
      LatLng(24.7740856, 46.5987857),
      LatLng(24.7738689, 46.5992011),
      LatLng(24.7739410, 46.5993483),
      LatLng(24.7741462, 46.5994157),
      LatLng(24.7743587, 46.5996949),
        
    ],
    strokeWidth: 0,
 fillColor: ZoneLogic.getZoneColorById('india'),
)};
 

 LatLng _getPolygonCenter(List<LatLng> points) {
  double lat = 0;
  double lng = 0;

  for (final point in points) {
    lat += point.latitude;
    lng += point.longitude;
  }

  return LatLng(lat / points.length, lng / points.length);
}

Future<Marker> _createTextMarker({
  required String id,
  required String text,
  required LatLng position,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(
        color: Color.fromARGB(255, 51, 51, 51),
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
    ),
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
    throw Exception('Failed to convert text marker to bytes');
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
      circles: _circles,
      onMapCreated: _onMapCreated,
      initialCameraPosition:  
      CameraPosition(
        target: _boulevardWorldCenter,
        zoom: 16,
      ),
      mapType: MapType.satellite,
    onTap: (LatLng point) {
  setState(() {
    _selectedUserLocation = point;
    _circles = LocationService.getUserLocationCircles(point);

    _polylines = {
      RouteService.buildRouteToZonePolyline(
        userLocation: point,
        toZoneId: 'japan',
      ),
    };

    _setDestinationMarker('japan', point);
  });
},
      cameraTargetBounds: _boulevardBounds,
      minMaxZoomPreference: const MinMaxZoomPreference(15.8, 19),
      markers: _markers,
      polygons: _polygons,
       zoomGesturesEnabled: true,      
       scrollGesturesEnabled: true,    
       rotateGesturesEnabled: true,   
       tiltGesturesEnabled: true,     

      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,
      compassEnabled: false,
      polylines: _polylines,
    );
  }
}