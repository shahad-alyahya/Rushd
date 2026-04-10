import 'package:google_maps_flutter/google_maps_flutter.dart';

class ZoneData {
  final String id;
  final String name;
  final LatLng entryPoint;
  final LatLng exitPoint;

  const ZoneData({
    required this.id,
    required this.name,
    required this.entryPoint,
    required this.exitPoint,
  });
}

class PathNode {
  final String id;
  final LatLng point;

  const PathNode({
    required this.id,
    required this.point,
  });
}
class MapData {
  // 📍 مركز البوليفارد
  static const LatLng boulevardWorldCenter = LatLng(24.7765, 46.6014);

  // 🧭 حدود الحركة
  static final CameraTargetBounds boulevardBounds = CameraTargetBounds(
    LatLngBounds(
      southwest: const LatLng(24.7717872, 46.5970640),
      northeast: const LatLng(24.7812052, 46.6057510),
    ),
  );

  // 👤 موقع المستخدم التجريبي
  static const LatLng mockUserLocation = LatLng(24.77560985506877, 46.60403173416853);

  // 📌 ماركر البوليفارد
  static const Marker boulevardMarker = Marker(
    markerId: MarkerId('boulevard_world'),
    position: LatLng(24.7760199, 46.6013703),
    infoWindow: InfoWindow(title: 'Boulevard World'),
  );

  // 🏙️ الزونات
  static final Map<String, ZoneData> zones = {
    'saudia': const ZoneData(
      id: 'saudia',
      name: 'Saudi Arabia',
      entryPoint: LatLng(24.773853362582095, 46.60012744367123),
      exitPoint: LatLng(24.774100551588905, 46.60110376775265),
    ),
    'china': const ZoneData(
      id: 'china',
      name: 'China',
      entryPoint: LatLng(24.774147432207098, 46.601164788007736),
      exitPoint: LatLng(24.774347740103522, 46.60170491784811),
    ),
    'sham': const ZoneData(
      id: 'sham',
      name: 'Sham',
      entryPoint: LatLng(24.77424545526063, 46.60174246877432),
      exitPoint: LatLng(24.77445854858826, 46.60224940627813),
    ),
    'moroco': const ZoneData(
      id: 'moroco',
      name: 'Morocco',
      entryPoint: LatLng(24.77461623741522, 46.6024324670434),
      exitPoint: LatLng(24.775345317322007, 46.602962873876095),
    ),
    'italy': const ZoneData(
      id: 'italy',
      name: 'Italy',
      entryPoint: LatLng(24.77580102814129, 46.60222593694925),
      exitPoint: LatLng(24.776453388814037, 46.60255920141935),
    ),
    'kuwait': const ZoneData(
      id: 'kuwait',
      name: 'Kuwait',
      entryPoint: LatLng(24.775324008157913, 46.60339035093784),
      exitPoint: LatLng(24.776057041301176, 46.60368137061596),
    ),
    'greece': const ZoneData(
      id: 'greece',
      name: 'Greece',
      entryPoint: LatLng(24.776236341523266, 46.60328675061464),
      exitPoint: LatLng(24.777131012275685, 46.60319320857525),
    ),
    'Egypt': const ZoneData(
      id: 'Egypt',
      name: 'Egypt',
      entryPoint: LatLng(24.777224771205454, 46.60328675061464),
      exitPoint: LatLng(24.778257027987344, 46.60257328301668),
    ),
    'turky': const ZoneData(
      id: 'turky',
      name: 'Turkey',
      entryPoint: LatLng(24.778257027987344, 46.602451242506504),
      exitPoint: LatLng(24.77865732578594, 46.60007581114769),
    ),
    'Spain': const ZoneData(
      id: 'Spain',
      name: 'Spain',
      entryPoint: LatLng(24.778572395790555, 46.599878668785095),
      exitPoint: LatLng(24.778145918483563, 46.59919302910566),
    ),
    'US': const ZoneData(
      id: 'US',
      name: 'United States',
      entryPoint: LatLng(24.778120043653324, 46.59908976405859),
      exitPoint: LatLng(24.77748960935833, 46.598620377480984),
    ),
    'japan': const ZoneData(
      id: 'japan',
      name: 'Japan',
      entryPoint: LatLng(24.777267997701195, 46.59864854067564),
      exitPoint: LatLng(24.775989156769214, 46.59813221544027),
    ),
    'india': const ZoneData(
      id: 'india',
      name: 'India',
      entryPoint: LatLng(24.77594653865842, 46.59820698201656),
      exitPoint: LatLng(24.77418122277155, 46.59940894693136),
    ),
  };
static final Map<String, LatLng> zoneLabelCenters = {
  'saudia': const LatLng(24.773739509351824, 46.6007212176919),
  'china': const LatLng(24.774793408792654, 46.60119563341141),
  'sham': const LatLng(24.774088374802076, 46.60218436270952),
  'moroco': const LatLng(24.77512004883088, 46.60248678177595),
  'italy': const LatLng(24.776270435933487, 46.60203751176596),
  'kuwait': const LatLng(24.775334967157047, 46.60405620932579),
  'greece': const LatLng(24.776700877057003, 46.603173427283764),
  'Egypt': const LatLng(24.777947443177226, 46.60313252359629),
  'turky': const LatLng( 24.77868989748919, 46.60145681351423),
  'Spain': const LatLng(24.778029329500022, 46.59984648227692),
  'US': const LatLng(24.777873471471125, 46.598792374134064),
  'japan': const LatLng(24.776760237632292, 46.59818720072508),
  'india': const LatLng(24.7751425756984, 46.598743088543415),
};
static final Map<String, String> zoneLabelTexts = {
  'saudia': 'Saudi Arabia\nZone',
  'china': 'China\nZone',
  'sham': 'Syria\nZone',
  'moroco': 'Morocco\nZone',
  'italy': 'Italy\nZone',
  'kuwait': 'Kuwait\nZone',
  'greece': 'Greek\nZone',
  'Egypt': 'Egypt\nZone',
  'turky': 'Turkey\nZone',
  'Spain': 'Spain\nZone',
  'US': 'US\nZone',
  'japan': 'Japanese\nZone',
  'india': 'India\nZone',
};
  // 🛣️ نقاط الممرات الرئيسية
  static final Map<String, PathNode> pathNodes = {
    'p1': const PathNode(id: 'p1', point: LatLng(24.773991569304215, 46.59973215311766)),
    'p2': const PathNode(id: 'p2', point: LatLng(24.774125513998182, 46.601064540445805)),
    'p3': const PathNode(id: 'p3', point: LatLng(24.7745188234917, 46.60188194364309)),
    'p4': const PathNode(id: 'p4', point: LatLng(24.775710007877567, 46.60344332456589)),
    'p5': const PathNode(id: 'p5', point: LatLng(24.77628504782071, 46.6035496070981)),
    'p6': const PathNode(id: 'p6', point: LatLng(24.777172107919196, 46.60312883555889)),
    'p7': const PathNode(id: 'p7', point: LatLng(24.778262811767025, 46.60250756889582)),
    'p8': const PathNode(id: 'p8', point: LatLng(24.77867559029348, 46.59999702125788)),
    'p9': const PathNode(id: 'p9', point: LatLng(24.778003759055586, 46.599265448749065)),
    'p10': const PathNode(id: 'p10', point: LatLng(24.77735414623578, 46.598703525960445)),
    'p11': const PathNode(id: 'p11', point: LatLng(24.776027208641487, 46.59839507192373)),
    
  };

  // الربط
  static final Map<String, List<String>> pathEdges = {
  'p1': ['p2', 'p11'],
  'p2': ['p1', 'p3'],
  'p3': ['p2', 'p4'],
  'p4': ['p3', 'p5'],
  'p5': ['p4', 'p6'],
  'p6': ['p5', 'p7'],
  'p7': ['p6', 'p8'],
  'p8': ['p7', 'p9'],
  'p9': ['p8', 'p10'],
  'p10': ['p9', 'p11'],
  'p11': ['p10', 'p1'],
};

  // 🚪 أقرب نقطة ممر لمدخل كل زون
  static final Map<String, String> zoneEntryNodes = {
    'saudia': 'p1',
    'china': 'p2',
    'sham': 'p3',
    'moroco': 'p4',
    'italy': 'p4',
    'kuwait': 'p4',
    'greece': 'p5',
    'Egypt': 'p6',
    'turky': 'p7',
    'Spain': 'p8',
    'US': 'p9',
    'japan': 'p10',
    'india': 'p11',
  };

  // 🚪 أقرب نقطة ممر لمخرج كل زون
  static final Map<String, String> zoneExitNodes = {
    'saudia': 'p2',
    'china': 'p3',
    'sham': 'p3',
    'moroco': 'p4',
    'italy': 'p4',
    'kuwait': 'p5',
    'greece': 'p6',
    'Egypt': 'p7',
    'turky': 'p8',
    'Spain': 'p9',
    'US': 'p10',
    'japan': 'p11',
    'india': 'p1',
  };
}