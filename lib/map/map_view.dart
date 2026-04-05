import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;

  // مركز تقريبي داخل منطقة البوليفارد
  static const LatLng _boulevardWorldCenter = LatLng(24.7765, 46.6014);

  // نحصر الحركة داخل مساحة صغيرة فقط
  static final CameraTargetBounds _boulevardBounds = CameraTargetBounds(
    LatLngBounds(
      southwest: const LatLng(24.7717872, 46.5970640),
      northeast: const LatLng(24.7812052, 46.6057510),
    ),
  );

  final Set<Marker> _markers =  {
    const Marker(
      markerId: MarkerId('boulevard_world'),
      position: LatLng(24.7760199, 46.6013703),
      infoWindow: InfoWindow(title: 'Boulevard World'),
    ),
   
  };

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
  // LAKE
  Polygon(
    polygonId: PolygonId('lake'),
    points: [
      LatLng(24.77710, 46.60070),
      LatLng(24.77720, 46.60220),
      LatLng(24.77680, 46.60320),
      LatLng(24.77600, 46.60370),
      LatLng(24.77480, 46.60320),
      LatLng(24.77450, 46.60180),
      LatLng(24.77480, 46.60060),
      LatLng(24.77580, 46.60030),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFF6EC6FF).withOpacity(0.30),
  ),

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
    fillColor: Color.fromARGB(255, 227, 80, 80),
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
    fillColor: Color.fromARGB(255, 154, 227, 134),
  ),

  // 3 - أعلى وسط
  Polygon(
    polygonId: PolygonId('sham'),
    points: [
      LatLng(24.7742643, 46.6017612),
      LatLng(24.7744065, 46.6018400),
      LatLng(24.7745270, 46.6021522),
      LatLng(24.7744847, 46.6023366),
      LatLng(24.7741401, 46.6025052),
      LatLng(24.7739060, 46.6018987),
      LatLng(24.7742208, 46.6017488),

    ],
    strokeWidth: 0,
    fillColor: Color.fromARGB(255, 248, 223, 156),
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
    fillColor: Color.fromARGB(255, 190, 240, 170),
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
    fillColor: Color.fromARGB(255, 165, 209, 117),
  ),

  // 6 - يمين وسط
  Polygon(
    polygonId: PolygonId('games'),
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
    fillColor: Color.fromARGB(255, 237, 211, 120),
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
    fillColor: Color.fromARGB(255, 211, 54, 54),
  ),

  // 8 - أسفل يمين
  Polygon(
    polygonId: PolygonId('z8'),
    points: [
      LatLng(24.77485, 46.60270),
      LatLng(24.77505, 46.60445),
      LatLng(24.77415, 46.60530),
      LatLng(24.77310, 46.60495),
      LatLng(24.77300, 46.60335),
      LatLng(24.77375, 46.60245),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFFD6F0D2).withOpacity(0.25),
  ),

  // 9 - أسفل
  Polygon(
    polygonId: PolygonId('z9'),
    points: [
      LatLng(24.77420, 46.60090),
      LatLng(24.77435, 46.60270),
      LatLng(24.77360, 46.60340),
      LatLng(24.77255, 46.60300),
      LatLng(24.77245, 46.60130),
      LatLng(24.77320, 46.60055),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFFBFD8F2).withOpacity(0.25),
  ),

  // 10 - أسفل يسار
  Polygon(
    polygonId: PolygonId('z10'),
    points: [
      LatLng(24.77455, 46.59900),
      LatLng(24.77470, 46.60080),
      LatLng(24.77400, 46.60135),
      LatLng(24.77295, 46.60100),
      LatLng(24.77280, 46.59930),
      LatLng(24.77345, 46.59855),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFFAED6A3).withOpacity(0.25),
  ),

  // 11 - يسار وسط
  Polygon(
    polygonId: PolygonId('z11'),
    points: [
      LatLng(24.77630, 46.59785),
      LatLng(24.77645, 46.59965),
      LatLng(24.77570, 46.60020),
      LatLng(24.77470, 46.59990),
      LatLng(24.77445, 46.59830),
      LatLng(24.77510, 46.59755),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFFCDE7BE).withOpacity(0.25),
  ),

  // 12 - يسار أعلى
  Polygon(
    polygonId: PolygonId('z12'),
    points: [
      LatLng(24.77820, 46.59740),
      LatLng(24.77835, 46.59910),
      LatLng(24.77765, 46.59970),
      LatLng(24.77680, 46.59935),
      LatLng(24.77660, 46.59785),
      LatLng(24.77715, 46.59715),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFFF7D9A8).withOpacity(0.25),
  ),

};
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition:  
      CameraPosition(
        target: _boulevardWorldCenter,
        zoom: 15.7,
      ),
      mapType: MapType.satellite,
      cameraTargetBounds: _boulevardBounds,
      minMaxZoomPreference: const MinMaxZoomPreference(15.8, 19.0),
      markers: _markers,
      polygons: _polygons,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      polylines: const <Polyline>{},
    );
  }
}