import 'package:flutter/material.dart';
import 'ZoneAlerts-1.dart';
import 'package:rushd/Security/security_bottom_bar.dart';

class ZoneAlerts2Screen extends StatelessWidget {
  const ZoneAlerts2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380, // iPhone Style alignment
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

                        // Navigation toggle focused on "Responded" alerts
                        _buildAlertToggle(context),

                        const SizedBox(height: 24),

                        // List of security alerts that have been successfully resolved
                        const AlertCardResponded(
                          imagePath: 'assets/images/egypt.png',
                          title: 'Egyptian Subzone',
                          date: '19 Dec 2025',
                          timeAgo: '40 minutes ago',
                          levelText: 'Low Level',
                          levelBg: Color(0x334CAF50),
                          levelTextColor: Color(0xFF2E7D32),
                        ),
                      ],
                    ),
                  ),
                ),
                // Reusable Bottom Bar with Alert section highlighted
                const SecurityBottomBar(currentIndex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Toggle widget to navigate back to Active Alerts
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
                  // Navigate back to Active Alerts screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ZoneAlerts1Screen(),
                    ),
                  );
                },
                child: const Center(
                  child: Text(
                    'Active Alerts',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9B9B9B)),
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
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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

// Reusable card widget for responded/closed alerts
class AlertCardResponded extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
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
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14),
                    const SizedBox(width: 5),
                    Text(date, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14),
                    const SizedBox(width: 5),
                    Text(timeAgo, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                // Response level badge (e.g., Safe/Low Level)
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
