import 'package:flutter/material.dart';
import 'ZoneAlerts-2.dart';
import 'package:rushd/Security/security_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ZoneAlerts1Screen extends StatelessWidget {
  final String locationId;

  const ZoneAlerts1Screen({

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

                        /// 🔥 هنا الفايربيس
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('zones')
                              .where('locationId',
                                  isEqualTo: locationId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Text("No alerts");
                            }

                            final docs = snapshot.data!.docs;

                            /// 👇 فلترة high + medium فقط
                            final filtered = docs.where((doc) {
                              final data =
                                  doc.data() as Map<String, dynamic>;
                              final level = (data['congestionLevel'] ?? '')
                                  .toString()
                                  .toLowerCase();
                              return level == 'high' ||
                                  level == 'medium';
                            }).toList();

                            if (filtered.isEmpty) {
                              return const Text("No active alerts");
                            }

                            return Column(
                              children: filtered.map((doc) {
                                final data =
                                    doc.data() as Map<String, dynamic>;

                                final zoneName =
                                    (data['zoneName'] ?? 'Zone')
                                        .toString();

                                final level =
                                    (data['congestionLevel'] ?? 'low')
                                        .toString();

                                final updatedAt = data['lastUpdated'];

                                return Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 20),
                                child: AlertCardActive(
  imagePath: _imageForZone(zoneName),
  title: zoneName,
  date: '',
  timeAgo: _formatTime(updatedAt),
  levelText: _levelText(level),
  levelBg: _levelBg(level),
  levelTextColor: _levelColor(level),
  locationId: (data['locationId'] ?? '').toString(), // 🔥 هذا المهم
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

  /// 🔥 صور حسب الزون
String _imageForZone(String zoneName) {
  final name = zoneName.toLowerCase();

  if (name.contains('saudi')) {
    return 'assets/images/saudiZone.png';
  } else if (name.contains('turkey')) {
    return 'assets/images/turkey.png';
  } else if (name.contains('india')) {
    return 'assets/images/india.png';
  } else if (name.contains('japan') || name.contains('japanese')) {
    return 'assets/images/japan.png';
  } else if (name.contains('china')) {
    return 'assets/images/china.png';
  } else if (name.contains('egypt')) {
    return 'assets/images/egypt.png';
  } else if (name.contains('greek')) {
    return 'assets/images/greek.png';
  } else if (name.contains('morocco')) {
    return 'assets/images/morocco.png';
  }

  return 'assets/images/saudiZone.png';
}
  /// 🔥 Level text
  String _levelText(String level) {
    if (level == 'high') return 'High Level';
    if (level == 'medium') return 'Medium Level';
    return 'Low Level';
  }

  Color _levelBg(String level) {
    if (level == 'high') return const Color(0x33C22222);
    if (level == 'medium') return const Color(0x33C26722);
    return const Color(0x334CAF50);
  }

  Color _levelColor(String level) {
    if (level == 'high') return const Color(0xFFE11A1A);
    if (level == 'medium') return const Color(0xFFF87927);
    return const Color(0xFF2E7D32);
  }

  /// 🔥 time ago
  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return '';

    final date = (timestamp as Timestamp).toDate();
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';

    return '${diff.inDays} days ago';
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x12000000), blurRadius: 6),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Active Alerts',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                           ZoneAlerts2Screen(locationId: locationId),
                    ),
                  );
                },
                child: const Center(
                  child: Text(
                    'Responded Alerts',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9B9B9B)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class AlertCardActive extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String timeAgo;
  final String levelText;
  final Color levelBg;
  final String locationId;
  final Color levelTextColor;

  const AlertCardActive({
    super.key,
    required this.imagePath,
    required this.title,
    required this.date,
    required this.timeAgo,
    required this.levelText,
    required this.levelBg,
    required this.levelTextColor,
   required this.locationId,
  });

  @override
  Widget build(BuildContext context) {
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
    if (locationId != 'test_area_001') ...[
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14),
              const SizedBox(width: 5),
              Text(timeAgo, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    ),

    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
  ],
),
    );
  }
}