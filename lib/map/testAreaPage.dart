import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'zonePoint.dart';
import 'routeData.dart';
import 'routePath.dart';
class TestAreaPage extends StatefulWidget {
  const TestAreaPage({super.key});

  @override
  State<TestAreaPage> createState() => _TestAreaPageState();
}

class _TestAreaPageState extends State<TestAreaPage> {
  
  GoogleMapController? mapController;
  

  static const LatLng center = LatLng(24.8260231, 46.6636767);
ZonePoint? selectedFrom;
ZonePoint? selectedTo;
final Set<Marker> markers = {};
final Set<Circle> circles = {};
   late final Set<Polygon> polygons ;
   
  final Set<Polyline> gates = {};

   // ===== الحد العلوي (فيه فتحة Hall) =====
 final Set<Polyline> borders = {
  // فتحة C
  Polyline(
    polylineId: const PolylineId('open_c'),
    points: const [
      LatLng(24.8261475234813, 46.66429225355387),
      LatLng(24.826053192954404, 46.66449744254351),
    ],
    color: Colors.grey.shade700,
    width: 3,
  ),

  // بين C و B
  Polyline(
    polylineId: const PolylineId('open_c_b'),
    points: const [
      LatLng(24.826882081964925, 46.663572415709496),
      LatLng(24.82667729455722, 46.66369680315256),
    ],
    color: Colors.grey.shade700,
    width: 3,
  ),

  // بين B و A
  Polyline(
    polylineId: const PolylineId('open_b_a'),
    points: const [
      LatLng(24.82592204297343, 46.66284419596195),
      LatLng(24.826034631132604, 46.663141921162605),
    ],
    color: Colors.grey.shade700,
    width: 3,
  ),

  // فتحة A
  Polyline(
    polylineId: const PolylineId('open_a'),
    points: const [
      LatLng(24.825475949423183, 46.66411589831114),
      LatLng(24.825177132790394, 46.66418798267841),
    ],
    color: Colors.grey.shade700,
    width: 3,
  ),

  // فتحة Hall
  Polyline(
    polylineId: const PolylineId('open_hall'),
    points: const [
      LatLng(24.825541676813902, 46.66481528431177),
      LatLng(24.825336887189867, 46.66472274810076),
    ],
    color: Colors.grey.shade800,
    width: 6,
  ),
};
   
void drawRoute(ZonePoint from, ZonePoint to) {
  final route = getRoute(from, to);
  if (route == null) return;

  setState(() {
    // الروت
    gates.removeWhere(
      (line) => line.polylineId.value == 'selected_route',
    );

    gates.add(
      Polyline(
        polylineId: const PolylineId('selected_route'),
        points: route.points,
        color: Colors.deepPurple,
        width: 8,
      ),
    );

    // حذف القديم
    markers.clear();
    circles.clear();

    final startPoint = route.points.first; // 🔵
    final endPoint = route.points.last;    // 🔴

    // 🔵 دائرة زرقاء (الظل)
    circles.add(
      Circle(
        circleId: const CircleId('user_circle'),
        center: startPoint,
        radius: 10, // كبر/صغر حسب ما يعجبك
        fillColor: Colors.blue.withOpacity(0.4),
        strokeColor: Colors.blue.withOpacity(0.7),
        strokeWidth: 2,
      ),
    );

    
    

    // 🔴 الوجهة (Pin أحمر)
    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: endPoint,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      ),
    );
  });
}
void handleZoneTap(ZonePoint zone) {
  if (selectedFrom == null) {
    setState(() {
      selectedFrom = zone;
    });

    print('start: $zone');
  } else if (selectedTo == null) {
    setState(() {
      selectedTo = zone;
    });

    print('end: $zone');
    drawRoute(selectedFrom!, selectedTo!);
  } else {
    setState(() {
      selectedFrom = zone;
      selectedTo = null;

      // حذف الروت
      gates.removeWhere(
        (line) => line.polylineId.value == 'selected_route',
      );

      // حذف كل الماركرات
      markers.clear();

      // حذف كل الدواير
      circles.clear();
    });

    print('reset: $zone');
  }
}
@override
void initState() {
  super.initState();
  polygons = {
    Polygon(
  polygonId: const PolygonId('hall'),
  points: const [
    LatLng(24.82449764177584, 46.66430063545704),
    LatLng(24.825253206339646, 46.6641591489315),
    LatLng(24.826268023017608, 46.663974076509476),
    LatLng(24.82607145048134, 46.664384454488754),
    LatLng(24.825859054418114, 46.664907820522785),
    LatLng(24.825234644397927, 46.66468217968941),
  ],
  fillColor: Colors.transparent ,
  strokeWidth: 0,
  consumeTapEvents: true,
  onTap: () {
    handleZoneTap(ZonePoint.gate);
  },
),
  Polygon(
  polygonId: const PolygonId('main_boundary'),
  points: const [
    LatLng(24.8276583, 46.6648039),
    LatLng(24.8276422, 46.6648512),
    LatLng(24.8269974, 46.6651838),
    LatLng(24.8267628, 46.6652454),
    LatLng(24.8265051, 46.6652263),
    LatLng(24.8261868, 46.6650872),
    LatLng(24.8248080, 46.6645497),
    LatLng(24.8245016, 46.6643519),
    LatLng(24.8242859, 46.6640985),
    LatLng(24.8239940, 46.6634118),
    LatLng(24.8240427, 46.6632834),
    LatLng(24.8264287, 46.6620841),
    LatLng(24.8265251, 46.6621002),
    LatLng(24.8270284, 46.6633498),
    LatLng(24.8276008, 46.6647097),
  ],

  // 👇 لون خفيف جدًا (خلفية)
  fillColor: Color(0xFF9E9E9E).withValues(alpha: 0.15),

  // 👇 الحدود
  strokeColor: Color(0xFF424242),
  strokeWidth: 3,
),
Polygon(
  polygonId: const PolygonId('zoneC'),
  points: const [
    LatLng(24.827674146566494, 46.66478343307972),
    LatLng(24.827655584987614, 46.66482400149107),
    LatLng(24.827013230929264, 46.66515324264765),
    LatLng(24.826779536158234, 46.66521392762661),
    LatLng(24.82653823367279, 46.66520554572344),
    LatLng(24.825838058225894, 46.66491620242596),
    LatLng(24.82629449638488, 46.66394256055355),
    LatLng(24.82708656474439, 46.66345104575157),
    LatLng(24.827422195717485, 46.664228551089764),
  ],
  fillColor: Color(0x44EF5350),
  strokeWidth: 0,
  consumeTapEvents: true,
  onTap: () {
    handleZoneTap(ZonePoint.c);
  }
),
Polygon(
  polygonId: const PolygonId('zoneB'),
  points: const [
    // فوق يمين
    LatLng(24.82711547225293, 46.66345976293087),

    // فوق يسار
    LatLng(24.826564706982303, 46.66207540780306),
    LatLng(24.82647281110203, 46.66204355657101),

    // تحت يسار
    LatLng(24.825709342360998, 46.662453934550285),

    // تحت يمين (مشترك مع A)
    LatLng(24.826312753876245, 46.66392210870981),
  ],
  fillColor: const Color(0x4456C271),
  strokeWidth: 0,
  consumeTapEvents: true,
  onTap: () {
    handleZoneTap(ZonePoint.b);
  },
),
Polygon(
  polygonId: const PolygonId('zoneA'),
  points: const [
    // فوق يمين (مشترك مع B)
    LatLng(24.826341661565415, 46.66392210870981),

    // فوق يسار
    LatLng(24.825735815847683, 46.662433817982674),
    LatLng(24.82408045131227, 46.66325457394123),
    LatLng(24.824041196995015, 46.66338734328747),

    // تحت
    LatLng(24.82432175858615, 46.66407532989979),
    LatLng(24.82449764177584, 46.66429225355387),
    LatLng(24.82456306538995, 46.66436433792114),

    // رجوع لنقطة الربط
    LatLng(24.826341661565415, 46.66392210870981),
  ],
  fillColor: const Color(0x445AA9FF),
  strokeWidth: 0,
  consumeTapEvents: true,
  onTap: () {
    handleZoneTap(ZonePoint.a);
  },
),
  };
 // drawRoute(ZonePoint.gate, ZonePoint.a);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Area")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: center,
          zoom: 17.5,
        ),
      mapType:   MapType.satellite,
      onTap: (LatLng point) {
 print('LatLng(${point.latitude}, ${point.longitude})');
},
        polygons: polygons,
        polylines:{...gates,...borders},
        markers: markers,   
        circles: circles,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
