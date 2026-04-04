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
      position: LatLng(24.7648, 46.6050),
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
    polygonId: const PolygonId('saudi_zone'),
    points: const [
      LatLng(24.7658, 46.6040),
      LatLng(24.7660, 46.6048),
      LatLng(24.7656, 46.6054),
      LatLng(24.7649, 46.6052),
      LatLng(24.7646, 46.6045),
      LatLng(24.7650, 46.6039),
    ],
    strokeWidth: 2,
    strokeColor: Colors.deepPurple,
    fillColor: Color(0x44D6C4FF),
  ),
  Polygon(
    polygonId: const PolygonId('morocco_zone'),
    points: const [
      LatLng(24.7648, 46.6039),
      LatLng(24.7650, 46.6048),
      LatLng(24.7646, 46.6055),
      LatLng(24.7639, 46.6052),
      LatLng(24.7637, 46.6045),
      LatLng(24.7641, 46.6038),
    ],
    strokeWidth: 2,
    strokeColor: Colors.green,
    fillColor: Color(0x4439D98A),
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
      polygons: {},
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      polylines: const <Polyline>{},
    );
  }
}