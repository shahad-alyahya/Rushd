import 'package:flutter/material.dart';
import 'alternative_route.dart';
import 'package:rushd/shared/VisitorBottomBar1.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rushd/map/map_view.dart';
import 'package:rushd/map/testAreaPage.dart';
import 'package:rushd/map/routeData.dart';
import 'package:rushd/map/route_utils.dart';
import 'package:rushd/map/zonePoint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class RoutesPage extends StatefulWidget {
  final String selectedLocation;

  const RoutesPage({super.key, required this.selectedLocation});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  static const Color kPurple = Color(0xFF867AB9);
  static const Color kDark = Color(0xFF353841);

  late String _selectedLocation;
  DateTime _lastUpdate = DateTime.now();

  LatLng? _selectedUserLocation;
  String? _selectedTestAreaZoneId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _zonesSub;

  Map<String, String> zoneLevels = {};

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.selectedLocation;
    _listenToZones();
  }

  @override
  void dispose() {
    _zonesSub?.cancel();
    super.dispose();
  }

  void _listenToZones() {
    _zonesSub = _firestore.collection('zones').snapshots().listen((snapshot) {
      final updated = <String, String>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        updated[doc.id] = (data['congestionLevel'] ?? 'low').toString();
      }
      if (mounted) {
        setState(() {
          zoneLevels = updated;
        });
      }
    });
  }

  Color _getLevelColor(String zoneId) {
    final level = zoneLevels[zoneId] ?? 'low';
    switch (level) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String _getLevelText(String zoneId) {
    final level = zoneLevels[zoneId] ?? 'low';
    switch (level) {
      case 'high':
        return 'High Level';
      case 'medium':
        return 'Medium Level';
      default:
        return 'Low Level';
    }
  }

  void _refresh() {
    setState(() {
      _lastUpdate = DateTime.now();
    });
  }

  String _formattedTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  ZonePoint _mapZoneIdToPoint(String id) {
    switch (id) {
      case 'zone_001':
        return ZonePoint.a;
      case 'zone_002':
        return ZonePoint.b;
      case 'zone_003':
        return ZonePoint.c;
      case 'hall':
        return ZonePoint.hall;
      default:
        return ZonePoint.a;
    }
  }

  String _routeZoneId(String id) {
    switch (id) {
      case 'zone_001':
        return 'zone_a';
      case 'zone_002':
        return 'zone_b';
      case 'zone_003':
        return 'zone_c';
      default:
        return id;
    }
  }

  String _getTime(ZonePoint to) {
    if (_selectedTestAreaZoneId == null) return "--";
    final from = _mapZoneIdToPoint(_selectedTestAreaZoneId!);
    final route = RouteData.getDirectRoute(from, to);
    if (route == null) return "--";
    return RouteUtils.estimateTime(route.points);
  }

  String _getDistance(ZonePoint to) {
    if (_selectedTestAreaZoneId == null || _selectedTestAreaZoneId!.isEmpty)
      return "--";
    final from = _mapZoneIdToPoint(_selectedTestAreaZoneId!);
    final route = RouteData.getDirectRoute(from, to);
    if (route == null) return "--";
    return RouteUtils.formatDistance(route.points);
  }

  @override
  Widget build(BuildContext context) {
    final bool isTestArea = _selectedLocation == 'Test Area';
    final bool hasSelection =
        _selectedTestAreaZoneId != null && _selectedTestAreaZoneId!.isNotEmpty;

    // 🔥 اللوجيك الجديد: تعريف كل المناطق المتاحة
    final List<Map<String, dynamic>> allZones = [
      {'id': 'zone_001', 'title': 'Zone A', 'point': ZonePoint.a},
      {'id': 'zone_002', 'title': 'Zone B', 'point': ZonePoint.b},
      {'id': 'zone_003', 'title': 'Zone C', 'point': ZonePoint.c},
    ];

    // 🔥 التصفية الديناميكية: نستبعد المنطقة اللي تم اختيارها كبداية
    List<Map<String, dynamic>> availableDestinations = [];
    if (hasSelection) {
      availableDestinations = allZones
          .where((zone) => zone['id'] != _selectedTestAreaZoneId)
          .toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    children: [
                      const SizedBox(height: 28),

                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 26,
                                color: kPurple,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _selectedLocation,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _refresh,
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text("Refresh"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kDark,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              Text(
                                "Last update: ${_formattedTime(_lastUpdate)}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        "Routes",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("Select your starting location on the map"),
                      const SizedBox(height: 16),

                      /// MAP
                      SizedBox(
                        height: 280,
                        child: isTestArea
                            ? TestAreaPage(
                                onLocationSelected:
                                    (LatLng point, String zoneId) {
                                      setState(() {
                                        _selectedUserLocation = point;
                                        _selectedTestAreaZoneId = zoneId;
                                      });
                                    },
                              )
                            : MapView(
                                mode: MapMode.selectLocation,
                                onLocationSelected: (point) {
                                  setState(() {
                                    _selectedUserLocation = point;
                                  });
                                },
                              ),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        "Best Nearby Destinations",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      /// رسالة توجيهية إذا ما اختار شيء
                      if (!hasSelection)
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Tap your current zone first to see available destinations",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),

                      /// 🔥 الكروت المتبقية تنبني تلقائياً بناءً على اللي بقى في اللستة
                      if (hasSelection)
                        ...availableDestinations.map((dest) {
                          return destinationCard(
                            title: dest['title'],
                            time: _getTime(dest['point']),
                            zoneId: dest['id'],
                            onGo: () {
                              if (_selectedUserLocation == null ||
                                  _selectedTestAreaZoneId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please select your current location first',
                                    ),
                                  ),
                                );
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlternativeRoute(
                                    zoneName: dest['title'], // اسم الوجهة
                                    locationName: "Test Area",
                                    distance: _getDistance(dest['point']),
                                    estimatedTime: _getTime(dest['point']),
                                    zoneId: _routeZoneId(
                                      dest['id'],
                                    ), // معرف الوجهة
                                    startZoneId: _routeZoneId(
                                      _selectedTestAreaZoneId!,
                                    ), // معرف البداية
                                    userLocation: _selectedUserLocation!,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                    ],
                  ),
                ),
                const VisitorBottomBar1(currentIndex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// CARD
  Widget destinationCard({
    required String title,
    required String time,
    required String zoneId,
    required VoidCallback onGo,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text("$time away"),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _getLevelColor(zoneId).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getLevelText(zoneId),
              style: TextStyle(
                color: _getLevelColor(zoneId),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: onGo, child: const Text("GO")),
        ],
      ),
    );
  }
}
