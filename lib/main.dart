import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
//import 'map/map_view.dart';
import 'map/riyadh_season_map.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken('pk.eyJ1IjoiamFuYS1tYXAiLCJhIjoiY21ua2t2NmEwMHl2bTJvcXRtbTc3dmd4OCJ9.IFJKzxCXiljylAhDapynfQ');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
     // home: MapView(),
      home: RiyadhSeasonMapView(),
    );
  }
}