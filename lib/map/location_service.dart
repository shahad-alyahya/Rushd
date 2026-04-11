import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static const LatLng mockLocation = LatLng(24.77560985506877, 46.60403173416853);

  static LatLng getCurrentLocation() {
    return mockLocation;
  }

  static Set<Circle> getUserLocationCircles(LatLng location) {
    return {
      Circle(
        circleId: const CircleId('glow'),
        center: location,
        radius: 30,
        fillColor: const Color.fromARGB(190, 0, 132, 255),
        strokeColor: Colors.transparent,
        strokeWidth: 0,
      ),
      Circle(
        circleId: const CircleId('dot'),
        center: location,
        radius: 12,
        fillColor: const Color.fromARGB(255, 2, 57, 116),
        strokeColor: Colors.white,
        strokeWidth: 3,
      ),
    };
  }
}