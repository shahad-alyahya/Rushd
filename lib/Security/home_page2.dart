import 'package:flutter/material.dart';
import 'package:rushd/map/map_view.dart';
import 'package:rushd/map/testAreaPage.dart';
import 'security_bottom_bar.dart';
import 'package:rushd/reading_listener.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SecurityDashboardPage extends StatefulWidget {
  const SecurityDashboardPage({super.key});

  @override
  State<SecurityDashboardPage> createState() => _SecurityDashboardPageState();
}

class _SecurityDashboardPageState extends State<SecurityDashboardPage> {
  String lastUpdate = "9:12";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _assignedLocationId;
  String selectedLocation = '';
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    ReadingListener().startListening();
    _loadAssignedLocation();
  }

  Future<void> _loadAssignedLocation() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        if (!mounted) return;
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        if (!mounted) return;
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      final userData = userDoc.data() ?? {};
      final locationId =
          (userData['assignedLocationId'] ?? '').toString().trim();

      if (locationId.isEmpty) {
        if (!mounted) return;
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      final locationDoc =
          await _firestore.collection('locations').doc(locationId).get();

      String locationName = locationId;

      if (locationDoc.exists) {
        final locationData = locationDoc.data() ?? {};
        locationName =
            (locationData['locationName'] ?? locationId).toString().trim();
      }

      if (!mounted) return;
      setState(() {
        _assignedLocationId = locationId;
        selectedLocation = locationName;
        _isLoadingLocation = false;
      });
    } catch (e) {
      debugPrint('Error loading assigned location: $e');
      if (!mounted) return;
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  bool get _isTestArea => _assignedLocationId == 'test_area_001';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380,
            child: Column(
              children: [
                Expanded(
                  child: _isLoadingLocation
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeader(),
                              const SizedBox(height: 20),
                              _buildAssignedLocationView(),
                              const SizedBox(height: 20),
                              _buildMapSection(),
                              const SizedBox(height: 30),
                              const Text(
                                'Real-Time Status of all Zones',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 15),
                              _buildAssignedLocationCards(),
                            ],
                          ),
                        ),
                ),
                SecurityBottomBar(
  currentIndex: 1,
  locationId: _assignedLocationId ?? '',
),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssignedLocationView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: Color(0xFF867AB9),
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              selectedLocation.isEmpty ? 'No location assigned' : selectedLocation,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1F2430),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Security Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Last update: $lastUpdate',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              final now = DateTime.now();
              lastUpdate =
                  "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
            });
          },
          icon: const Icon(Icons.refresh, color: Colors.black, size: 18),
          label: const Text(
            'Refresh',
            style: TextStyle(color: Colors.black, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _isTestArea
            ? const TestAreaPage()
            : const MapView(mode: MapMode.viewOnly),
      ),
    );
  }

  Widget _buildAssignedLocationCards() {
    if (_assignedLocationId == null || _assignedLocationId!.isEmpty) {
      return const Text('No location assigned');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('zones')
          .where('locationId', isEqualTo: _assignedLocationId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No zones found');
        }

        final docs = snapshot.data!.docs;

        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final zoneName = data['zoneName'] ?? 'Unknown';
            final level =
                (data['congestionLevel'] ?? 'low').toString().toLowerCase();

            String timeAgo = 'Updated';

            final lastUpdated = data['lastUpdated'];
            if (lastUpdated is Timestamp) {
              final diff = DateTime.now().difference(lastUpdated.toDate());

              if (diff.inMinutes < 1) {
                timeAgo = 'Just now';
              } else if (diff.inMinutes < 60) {
                timeAgo = '${diff.inMinutes} min ago';
              } else if (diff.inHours < 24) {
                timeAgo = '${diff.inHours} hr ago';
              } else {
                timeAgo = '${diff.inDays} day ago';
              }
            }

            if (level == 'high') {
              return _buildHighLevelZoneCard(zoneName, timeAgo);
            } else if (level == 'medium') {
              return _buildMediumLevelZoneCard(zoneName, timeAgo);
            } else {
              return _buildLowLevelZoneCard(zoneName, timeAgo);
            }
          }).toList(),
        );
      },
    );
  }

  Widget _buildZoneCard({
    required String zoneName,
    required String timeAgo,
    required String levelText,
    required Color levelColor,
    required Color levelTextColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                zoneName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                timeAgo,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: levelColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              levelText,
              style: TextStyle(
                color: levelTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighLevelZoneCard(String name, String time) => _buildZoneCard(
        zoneName: name,
        timeAgo: time,
        levelText: 'High Level',
        levelColor: const Color(0xFFFFEAEA),
        levelTextColor: const Color(0xFFEF5350),
      );

  Widget _buildMediumLevelZoneCard(String name, String time) => _buildZoneCard(
        zoneName: name,
        timeAgo: time,
        levelText: 'Medium Level',
        levelColor: const Color(0xFFFFF3E0),
        levelTextColor: const Color(0xFFFF9800),
      );

  Widget _buildLowLevelZoneCard(String name, String time) => _buildZoneCard(
        zoneName: name,
        timeAgo: time,
        levelText: 'Low Level',
        levelColor: const Color(0xFFE8F5E9),
        levelTextColor: const Color(0xFF66BB6A),
      );
}