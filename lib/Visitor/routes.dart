import 'package:flutter/material.dart';
import 'alternative_route.dart';
import 'package:rushd/shared/VisitorBottomBar1.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rushd/map/map_view.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  static const Color kPurple = Color(0xFF867AB9);
  static const Color kDark = Color(0xFF353841);

  String _selectedLocation = "Boulevard World";
  DateTime _lastUpdate = DateTime.now();

  LatLng? _selectedUserLocation;

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
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
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

                      const SizedBox(height: 20),

                      const Text(
                        "Routes",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        _selectedLocation,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      ClipRRect(
                     borderRadius: BorderRadius.circular(40),
                     child: SizedBox(
                     height: 291,
                     width: double.infinity,
                     child: MapView(
                     mode: MapMode.selectLocation,
                     onLocationSelected: (LatLng point) {
                     _selectedUserLocation = point;
                       },
                          ),
                      ),
                       ),

                      const SizedBox(height: 12),

                      const Text(
                        "Best Nearby Destinations (Low Crowd)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 12),

                      destinationCard(
                      title: "Morocco Zone",
                      time: "5 min away!",
                      image: "assets/images/morocco.png",
                      onGo: () {
                     if (_selectedUserLocation == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                    content: Text('Please select your current location first'),
                      ),
                    );
                      return;
                  }
                  Navigator.push(
                  context,
                 MaterialPageRoute(
                 builder: (context) => AlternativeRoute(
                zoneName: "Morocco Zone",
                locationName: "Boulevard World",
                distance: "320 m",
                 estimatedTime: "4 min",
                 zoneId: "moroco",
                 userLocation: _selectedUserLocation!,
                ),
                  ),
                   );
                     },
                    ),

                      const SizedBox(height: 18),

                      destinationCard(
                        title: "China Zone",
                        time: "11 min away!",
                        image: "assets/images/china.png",
                        onGo: () {
                      if (_selectedUserLocation == null) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                     content: Text('Please select your current location first'),
                    ),
                         );
                       return;
                      }

                   Navigator.push(
                 context,
                 MaterialPageRoute(
                  builder: (context) => AlternativeRoute(
                   zoneName: "China Zone",
                  locationName: "Boulevard World",
                   distance: "700 m",
                   estimatedTime: "11 min",
                   zoneId: "china",
                   userLocation: _selectedUserLocation!,
               ),
                    ),
                         );
                        },
                      ),

                      const SizedBox(height: 18),
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

  Widget destinationCard({
    required String title,
    required String time,
    required String image,
    required VoidCallback onGo,
  }) {
    return Container(
      height: 141,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.18),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                width: 146,
                height: 116,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7D7B7B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x3337C222),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Low Level",
                    style: TextStyle(
                      color: Color(0xFF27AE61),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onGo,
                  child: Container(
                    width: 116,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xFF353841),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "GO !",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}