import 'package:flutter/material.dart';
import 'ZoneAlerts-1.dart';
import 'package:rushd/Security/security_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ZoneAlerts2Screen extends StatelessWidget {
  final String locationId;

  const ZoneAlerts2Screen({

    super.key,

    required this.locationId,

  });

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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
                        const Text(
                          'Zone Alerts',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _buildAlertToggle(context),
                        const SizedBox(height: 24),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('zones')
                              .where('locationId', isEqualTo: 'test_area_001')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Text("No responded alerts");
                            }

                            final filtered = snapshot.data!.docs.where((doc) {
                              final data =
                                  doc.data() as Map<String, dynamic>;

                              final level = (data['congestionLevel'] ?? '')
                                  .toString()
                                  .trim()
                                  .toLowerCase();

                              return level == 'low';
                            }).toList();

                            if (filtered.isEmpty) {
                              return const Text("No responded alerts");
                            }

                            return Column(
                              children: filtered.map((doc) {
                                final data =
                                    doc.data() as Map<String, dynamic>;

                                final zoneId = doc.id;

                                final title = _zoneNameFromId(
                                  zoneId,
                                  (data['zoneName'] ?? 'Zone').toString(),
                                );

                                final updatedAt = data['lastUpdated'];
                                final timeAgo = _formatTime(updatedAt);

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: AlertCardResponded(
                                    imagePath: _imageForZone(zoneId),
                                    title: title,
                                    date: '',
                                    timeAgo: timeAgo,
                                    levelText: 'Low Level',
                                    levelBg: const Color(0x334CAF50),
                                    levelTextColor: const Color(0xFF2E7D32),
                                    locationId:
                                        (data['locationId'] ?? '').toString(),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
             SecurityBottomBar(
  currentIndex: 2,
  locationId: locationId,
),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertToggle(BuildContext context) {
    return Center(
      child: Container(
        width: 280,
        height: 46,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  ZoneAlerts1Screen(locationId: locationId),
                    ),
                  );
                },
                child: const Center(
                  child: Text(
                    'Active Alerts',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9B9B9B),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Color(0x12000000), blurRadius: 6),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Responded Alerts',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _zoneNameFromId(String zoneId, String fallback) {
    switch (zoneId) {
      case 'zone_00A':
        return 'Zone A';
      case 'zone_00B':
        return 'Zone B';
      case 'zone_00C':
        return 'Zone C';
      default:
        return fallback;
    }
  }

  String _imageForZone(String zoneId) {
    switch (zoneId) {
      case 'zone_00A':
        return 'assets/images/saudiZone.png';
      case 'zone_00B':
        return 'assets/images/AmusementPark.png';
      case 'zone_00C':
        return 'assets/images/china.png';
      default:
        return 'assets/images/egypt.png';
    }
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return '';

    final date = (timestamp as Timestamp).toDate();
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';

    return '${diff.inDays} days ago';
  }
}

class AlertCardResponded extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String locationId;
  final String timeAgo;
  final String levelText;
  final Color levelBg;
  final Color levelTextColor;

  const AlertCardResponded({
    super.key,
    required this.imagePath,
    required this.title,
    required this.date,
    required this.timeAgo,
    required this.levelText,
    required this.levelBg,
    required this.locationId,
    required this.levelTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTestArea = locationId == 'test_area_001';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isTestArea) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                imagePath,
                width: 110,
                height: 86,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14),
                    const SizedBox(width: 5),
                    Text(
                      timeAgo,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: levelBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      levelText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: levelTextColor,
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