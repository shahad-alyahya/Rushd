import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'routeData.dart';
import 'zonePoint.dart';

class RoutePath {
  final ZonePoint from;
  final ZonePoint to;
  final List<LatLng> points;

  RoutePath({
    required this.from,
    required this.to,
    required this.points,
  });
}

RoutePath? getRoute(ZonePoint from, ZonePoint to) {
  // 1️⃣ direct route
  final direct = RouteData.getDirectRoute(from, to);
  if (direct != null) {
    return RoutePath(
      from: from,
      to: to,
      points: direct.points,
    );
  }

  // 2️⃣ A → C عبر B
  if (from == ZonePoint.a && to == ZonePoint.c) {
    return _combine(
      from,
      to,
      RouteData.aToB,
      RouteData.bToC,
    );
  }

  // 3️⃣ C → A عبر B
  if (from == ZonePoint.c && to == ZonePoint.a) {
    return _combine(
      from,
      to,
      RouteData.cToB,
      RouteData.bToA,
    );
  }

  // 4️⃣ Hall → B عبر A
  if (from == ZonePoint.gate && to == ZonePoint.b) {
    return _combine(
      from,
      to,
      RouteData.gateToA,
      RouteData.aToB,
    );
  }

  // 5️⃣ B → Hall عبر A
  if (from == ZonePoint.b && to == ZonePoint.gate) {
    return _combine(
      from,
      to,
      RouteData.bToA,
      RouteData.aToGate,
    );
  }

  return null;
}
RoutePath _combine(
  ZonePoint from,
  ZonePoint to,
  RouteModel first,
  RouteModel second,
) {
  return RoutePath(
    from: from,
    to: to,
    points: [
      ...first.points,
      ...second.points,
    ],
  );
}