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
    polygonId: PolygonId('z1'),
    points: [
      LatLng(24.78070, 46.59730),
      LatLng(24.78095, 46.59910),
      LatLng(24.78030, 46.59990),
      LatLng(24.77920, 46.59960),
      LatLng(24.77890, 46.59810),
      LatLng(24.77960, 46.59720),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFFFFC1C1).withOpacity(0.25),
  ),

  // 2 - أعلى وسط يسار
  Polygon(
    polygonId: PolygonId('z2'),
    points: [
      LatLng(24.78095, 46.59890),
      LatLng(24.78110, 46.60070),
      LatLng(24.78055, 46.60155),
      LatLng(24.77935, 46.60120),
      LatLng(24.77910, 46.59965),
      LatLng(24.77980, 46.59870),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFFAED6A3).withOpacity(0.25),
  ),

  // 3 - أعلى وسط
  Polygon(
    polygonId: PolygonId('z3'),
    points: [
      LatLng(24.78100, 46.60060),
      LatLng(24.78115, 46.60220),
      LatLng(24.78065, 46.60320),
      LatLng(24.77955, 46.60290),
      LatLng(24.77925, 46.60140),
      LatLng(24.77995, 46.60045),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFFEED9A0).withOpacity(0.25),
  ),

  // 4 - أعلى يمين
  Polygon(
    polygonId: PolygonId('z4'),
    points: [
      LatLng(24.78085, 46.60210),
      LatLng(24.78100, 46.60420),
      LatLng(24.78025, 46.60530),
      LatLng(24.77925, 46.60485),
      LatLng(24.77920, 46.60300),
      LatLng(24.77985, 46.60200),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFFD9F0D0).withOpacity(0.25),
  ),

  // 5 - يمين أعلى
  Polygon(
    polygonId: PolygonId('z5'),
    points: [
      LatLng(24.77910, 46.60360),
      LatLng(24.77935, 46.60540),
      LatLng(24.77830, 46.60570),
      LatLng(24.77735, 46.60510),
      LatLng(24.77760, 46.60375),
      LatLng(24.77835, 46.60320),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFFCFE8B4).withOpacity(0.25),
  ),

  // 6 - يمين وسط
  Polygon(
    polygonId: PolygonId('z6'),
    points: [
      LatLng(24.77765, 46.60380),
      LatLng(24.77795, 46.60560),
      LatLng(24.77690, 46.60575),
      LatLng(24.77590, 46.60510),
      LatLng(24.77620, 46.60375),
      LatLng(24.77700, 46.60335),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFFF6E39B).withOpacity(0.25),
  ),

  // 7 - يمين أسفل
  Polygon(
    polygonId: PolygonId('z7'),
    points: [
      LatLng(24.77620, 46.60340),
      LatLng(24.77645, 46.60520),
      LatLng(24.77535, 46.60545),
      LatLng(24.77445, 46.60495),
      LatLng(24.77470, 46.60365),
      LatLng(24.77545, 46.60310),
    ],
    strokeWidth: 0,
    fillColor: Color(0xFFF1C27D).withOpacity(0.25),
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