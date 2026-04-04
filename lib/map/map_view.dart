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
  static const LatLng _boulevardWorldCenter = LatLng(24.7760199, 46.6013703);

  // نحصر الحركة داخل مساحة صغيرة فقط
  static final CameraTargetBounds _boulevardBounds = CameraTargetBounds(
    LatLngBounds(
      southwest: const LatLng(24.7738, 46.5988),
      northeast: const LatLng(24.7782, 46.6042),
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
  final Set<Polygon> _polygons = {
Polygon(
  polygonId: PolygonId('china'),
  points: [
    LatLng(24.7751, 46.6006),
    LatLng(24.7748, 46.6018),
    LatLng(24.7742, 46.6022),
    LatLng(24.7738, 46.6016),
    LatLng(24.7739, 46.6006),
    LatLng(24.7745, 46.6001),
  ],
  strokeWidth: 2,
  strokeColor: Colors.red,
  fillColor: Color(0x44FF0000),
),

Polygon(
  polygonId: PolygonId('morocco'),
  points: [
    LatLng(24.7746, 46.6022),
    LatLng(24.7744, 46.6035),
    LatLng(24.7738, 46.6039),
    LatLng(24.7733, 46.6032),
    LatLng(24.7736, 46.6024),
  ],
  strokeWidth: 2,
  strokeColor: Colors.green,
  fillColor: Color(0x4439D98A),
),

Polygon(
  polygonId: PolygonId('levant'),
  points: [
    LatLng(24.77365, 46.60120), // فوق يسار (نزلناه شوي)
    LatLng(24.77360, 46.60235), // فوق يمين

    LatLng(24.77315, 46.60285), // يمين تحت (بعدناه عن Morocco)
    LatLng(24.77280, 46.60210), // تحت (نزلناه)

    LatLng(24.77295, 46.60115), // يسار تحت
  ],
  strokeWidth: 2,
  strokeColor: Colors.orange,
  fillColor: Color(0x44FFA500),
),

Polygon(
  polygonId: PolygonId('italy'),
  points: [
    LatLng(24.77570, 46.60275), // فوق يسار
    LatLng(24.77580, 46.60375), // فوق يمين

    LatLng(24.77525, 46.60415), // يمين
    LatLng(24.77475, 46.60390), // تحت يمين

    LatLng(24.77465, 46.60330), // تحت
    LatLng(24.77510, 46.60270), // يسار
  ],
  strokeWidth: 2,
  strokeColor: Colors.pink,
  fillColor: Color(0x44FF4081),
),

Polygon(
  polygonId: PolygonId('warzone'),
  points: [
    LatLng(24.7753, 46.6044), // فوق يسار (رفع + ميل)
    LatLng(24.7756, 46.6057), // فوق يمين (أعلى نقطة)

    LatLng(24.7747, 46.6061), // يمين
   

    LatLng(24.7740, 46.6044), // تحت
    LatLng(24.7746, 46.6039), // يسار
  ],
  strokeWidth: 2,
  strokeColor: Colors.brown,
  fillColor: Color(0x445A3E2B),
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