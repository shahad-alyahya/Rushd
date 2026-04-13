import 'package:flutter/material.dart';
import 'ZoneAlerts-2.dart';
import 'package:rushd/Security/security_bottom_bar.dart';

class ZoneAlerts1Screen extends StatelessWidget {
  const ZoneAlerts1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            // Constraint to maintain a consistent iPhone-style layout (380px)
            width: 380,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    // iOS-style bounce scroll for a premium feel
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

                        // Navigation toggle between Active and Responded alerts
                        _buildAlertToggle(context),

                        const SizedBox(height: 24),

                        // List of current active security alerts
                        const AlertCardActive(
                          imagePath: 'assets/images/saudiZone.png',
                          title: 'Saudi Arabia Zone',
                          date: '27 Dec 2025',
                          timeAgo: '4 minutes ago',
                          levelText: 'High Level',
                          levelBg: Color(0x33C22222),
                          levelTextColor: Color(0xFFE11A1A),
                        ),
                        const SizedBox(height: 20),
                        const AlertCardActive(
                          imagePath: 'assets/images/AmusementPark.png',
                          title: 'Amusement Park',
                          date: '27 Dec 2025',
                          timeAgo: '8 minutes ago',
                          levelText: 'Medium Level',
                          levelBg: Color(0x33C26722),
                          levelTextColor: Color(0xFFF87927),
                        ),
                      ],
                    ),
                  ),
                ),
                // Fixed Security Bottom Bar (Always visible at the bottom)
                const SecurityBottomBar(currentIndex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Toggle switch to handle navigation between alert screens
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
                    BoxShadow(color: Color(0x12000000), blurRadius: 6),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Active Alerts',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Replaces current view with the Responded Alerts screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ZoneAlerts2Screen(),
                    ),
                  );
                },
                child: const Center(
                  child: Text(
                    'Responded Alerts',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9B9B9B)),
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

// Reusable card widget for active security alerts
class AlertCardActive extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String timeAgo;
  final String levelText;
  final Color levelBg;
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
          // Styled image for the zone with rounded corners
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
                // Date metadata row
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14),
                    const SizedBox(width: 5),
                    Text(date, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                // Time metadata row
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14),
                    const SizedBox(width: 5),
                    Text(timeAgo, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                // Threat level badge
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
