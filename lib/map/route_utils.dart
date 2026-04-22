import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteUtils {
  // حساب المسافة بين نقطتين (بالمتر)
  static double _distance(LatLng a, LatLng b) {
    const R = 6371000; // radius of earth in meters

    double dLat = _degToRad(b.latitude - a.latitude);
    double dLng = _degToRad(b.longitude - a.longitude);

    double lat1 = _degToRad(a.latitude);
    double lat2 = _degToRad(b.latitude);

    double aCalc = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLng / 2) * sin(dLng / 2) * cos(lat1) * cos(lat2);

    double c = 2 * atan2(sqrt(aCalc), sqrt(1 - aCalc));

    return R * c;
  }

  static double _degToRad(double deg) => deg * pi / 180;

  // 🔥 حساب طول الروت كامل
  static double calculateRouteDistance(List<LatLng> points) {
    double total = 0;

    for (int i = 0; i < points.length - 1; i++) {
      total += _distance(points[i], points[i + 1]);
    }

    return total; // بالمتر
  }
static String formatDistance(List<LatLng> points) {
  final distance = calculateRouteDistance(points);

  if (distance < 1000) {
    return "${distance.round()} m";
  } else {
    return "${(distance / 1000).toStringAsFixed(1)} km";
  }
}

  // 🔥 تحويل المسافة إلى وقت
  static String estimateTime(List<LatLng> points) {
    final distance = calculateRouteDistance(points);

    const speed = 1.4; // m/s (سرعة مشي)

    final seconds = distance / speed;
    final minutes = (seconds / 60).ceil();

    return "$minutes min";
  }
}