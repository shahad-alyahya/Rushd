import 'package:flutter/material.dart';
import 'package:rushd/map/route_utils.dart';
import 'package:rushd/map/routeData.dart';
import 'package:rushd/map/zonePoint.dart';
import 'package:rushd/map/testAreaPage.dart';
import 'package:rushd/map/map_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'alternative_route.dart';
import 'package:rushd/shared/VisitorBottomBar1.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Represents the main routing page where visitors can select their current
/// location on the map and view available nearby destinations dynamically.
class RoutesPage extends StatefulWidget {
  final String selectedLocation;

  const RoutesPage({super.key, required this.selectedLocation});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  // Theme colors
  static const Color kPurple = Color(0xFF867AB9);
  static const Color kDark = Color(0xFF353841);

  late String _selectedLocation;
  DateTime _lastUpdate = DateTime.now();

  // State variables for map interactions
  LatLng? _selectedUserLocation;
  String? _selectedTestAreaZoneId;

  // Firebase integration for real-time congestion updates
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _zonesSub;
  Map<String, String> zoneLevels = {};

  /// A centralized configuration list mapping physical zones to their respective IDs,
  /// display titles, and route point enumerations. This ensures dynamic scalability.
  final List<Map<String, dynamic>> _allPossibleDestinations = [
    {'id': 'zone_001', 'title': 'Zone A', 'point': ZonePoint.a},
    {'id': 'zone_002', 'title': 'Zone B', 'point': ZonePoint.b},
    {'id': 'zone_003', 'title': 'Zone C', 'point': ZonePoint.c},
  ];

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

  /// Establishes a real-time listener to the Firestore 'zones' collection
  /// to stream live congestion levels and update the UI accordingly.
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

  /// Returns the corresponding UI color based on the zone's real-time congestion level.
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

  /// Returns the corresponding textual description for the zone's congestion level.
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

  /// Triggers a manual UI refresh and updates the timestamp.
  void _refresh() {
    setState(() {
      _lastUpdate = DateTime.now();
    });
  }

  /// Formats the DateTime object into a readable HH:MM string.
  String _formattedTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  /// Maps the raw string identifiers from the map/database to the strongly-typed
  /// [ZonePoint] enum utilized by the routing engine.
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
        return ZonePoint.a; // Fallback default
    }
  }

  /// Standardizes zone identifiers to ensure compatibility when passing
  /// parameters to the map drawing algorithms in [AlternativeRoute].
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

  /// Calculates the estimated travel time dynamically based on the user's
  /// currently selected starting zone and the target destination.
  String _getTime(ZonePoint to) {
    if (_selectedTestAreaZoneId == null) return "--";

    final from = _mapZoneIdToPoint(_selectedTestAreaZoneId!);
    final route = RouteData.getDirectRoute(from, to);

    if (route == null) return "--";

    return RouteUtils.estimateTime(route.points);
  }

  /// Calculates the estimated physical distance between the dynamically selected
  /// start zone and the target destination.
  String _getDistance(ZonePoint to) {
    if (_selectedTestAreaZoneId == null || _selectedTestAreaZoneId!.isEmpty) {
      return "--";
    }

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

    // ==========================================
    // DYNAMIC FILTERING LOGIC
    // ==========================================
    // Initialize with all available zones
    List<Map<String, dynamic>> availableDestinations = _allPossibleDestinations;

    // If the user has selected a starting zone, filter it out of the destination list
    // to prevent circular routing (e.g., routing from Zone B to Zone B).
    if (hasSelection) {
      availableDestinations = _allPossibleDestinations
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

                      /// HEADER SECTION
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
                      const Text("Select your current location on the map"),
                      const SizedBox(height: 16),

                      /// MAP INTERACTION AREA
                      SizedBox(
                        height: 280,
                        child: isTestArea
                            ? TestAreaPage(
                                onLocationSelected: (LatLng point, String zoneId) {
                                  setState(() {
                                    // Update internal state with the user's explicit selection
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

                      /// Instructional prompt shown before user interaction
                      if (!hasSelection)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Tap your zone first on the map to see available destinations",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),

                      /// DYNAMIC DESTINATION CARDS
                      /// Generates route cards strictly for valid destinations,
                      /// utilizing the dynamically filtered list.
                      if (hasSelection)
                        ...availableDestinations.map((dest) {
                          return destinationCard(
                            title: dest['title'],
                            time: _getTime(dest['point']),
                            zoneId: dest['id'],
                            onGo: () {
                              // Validation check to ensure starting coordinates exist
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

                              // Navigate to the alternative route view, injecting the dynamically
                              // calculated start and end zone identifiers to render the accurate path.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlternativeRoute(
                                    zoneName:
                                        dest['title'], // Target Destination Name
                                    locationName: "Test Area",
                                    distance: _getDistance(dest['point']),
                                    estimatedTime: _getTime(dest['point']),

                                    // Pass standardized IDs for accurate map polyline drawing
                                    zoneId: _routeZoneId(
                                      dest['id'],
                                    ), // End Point
                                    startZoneId: _routeZoneId(
                                      _selectedTestAreaZoneId!,
                                    ), // Start Point

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
                // Custom bottom navigation bar
                const VisitorBottomBar1(currentIndex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// A reusable UI component that builds individual destination cards.
  /// Displays the zone name, estimated travel time, and real-time congestion level.
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

          // Congestion level indicator badge
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

          // Action button initiating the route generation
          ElevatedButton(onPressed: onGo, child: const Text("GO")),
        ],
      ),
    );
  }
}
