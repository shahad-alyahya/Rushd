import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rushd/map/map_view.dart';

class AlternativeRoute extends StatefulWidget {
  final String zoneName;
  final String locationName;
  final String distance;
  final String estimatedTime;
  final String zoneId;
  final LatLng userLocation;

  const AlternativeRoute({
    super.key,
    required this.zoneName,
    required this.locationName,
    required this.distance,
    required this.estimatedTime,
    required this.zoneId,
    required this.userLocation,
  });

  @override
  State<AlternativeRoute> createState() => _AlternativeRouteState();
}

class _AlternativeRouteState extends State<AlternativeRoute> {
  static const Color kPurple = Color(0xFF867AB9);
  static const Color kDark = Color(0xFF353841);

  DateTime _lastUpdate = DateTime.now();

  void _refresh() {
    setState(() {
      _lastUpdate = DateTime.now();
    });
  }

  String _formattedTime(DateTime dateTime) {
    final hh = dateTime.hour.toString().padLeft(2, '0');
    final mm = dateTime.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      const SizedBox(height: 28),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 26,
                                color: kPurple,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Boulevard World",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _refresh,
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text("Refresh"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kDark,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(0, 28),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 0,
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Last update: ${_formattedTime(_lastUpdate)}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                   borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(0),
                  ),
                child: SizedBox(
                   width: double.infinity,
                height: double.infinity,
                  child: MapView(
                      mode: MapMode.navigation,
                initialUserLocation: widget.userLocation,
                destinationZoneId: widget.zoneId,
              ),
                  ),
             ),

                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(42),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 90,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0x80B2B2B2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              Text(
                                widget.zoneName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 18),

                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      widget.locationName,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  const Icon(Icons.directions_walk, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Distance: ${widget.distance}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Estimated time: ${widget.estimatedTime}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 163,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF8A8A),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "exit",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}