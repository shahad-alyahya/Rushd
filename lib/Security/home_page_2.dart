import 'package:flutter/material.dart';

// --- RUSHD Theme Colors (Consistent with Project Report) ---
class RashadColors {
  static const Color primaryBlue = Color(0xFF0C2D48); // Navy Blue [cite: 2523]
  static const Color accentRed = Color(0xFFC62828);    // High Level [cite: 3199]
  static const Color accentOrange = Color(0xFFEF6C00); // Medium Level [cite: 3199]
  static const Color accentGreen = Color(0xFF2E7D32);  // Low Level [cite: 3199]
  static const Color lightGray = Color(0xFFF1F4F8);   // Background
}

class SecurityDashboardPage extends StatelessWidget {
  const SecurityDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Security Dashboard', // [cite: 3486]
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {}, 
            icon: const Icon(Icons.refresh, color: Colors.black),
            label: const Text('Refresh', style: TextStyle(color: Colors.black)), // [cite: 3492]
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Last update: 9:12', style: TextStyle(color: Colors.grey)), // [cite: 3487]
            ),
            // --- Interactive Map Placeholder (Matching Image) ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/map_placeholder.png', // تأكدي من إضافة صورة الخريطة في الـ assets [cite: 2001]
                fit: BoxFit.contain,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Real-Time Status of all Zones', // [cite: 3502]
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            // --- Dynamic Zone Cards List ---
            _buildZoneCard('Saudi Arabia Zone', '4 minutes ago', 'High Level', RashadColors.accentRed), // [cite: 3503]
            _buildZoneCard('Turkey Zone', '12 minutes ago', 'Medium Level', RashadColors.accentOrange), // [cite: 3505]
            _buildZoneCard('Japanese Zone', '6 minutes ago', 'Low Level', RashadColors.accentGreen), // [cite: 3506]
            _buildZoneCard('Greek Subzone', '5 minutes ago', 'Low Level', RashadColors.accentGreen), // [cite: 3507]
          ],
        ),
      ),
      // --- Bottom Navigation Bar (Matching Image) ---
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Widget to build individual Zone Status Cards [cite: 2220]
  Widget _buildZoneCard(String name, String time, String status, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // [cite: 2305]
              const SizedBox(height: 5),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 14)), // [cite: 2305]
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)), // [cite: 2198]
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar with Zone Alert Highlight [cite: 2310, 3509]
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      selectedItemColor: RashadColors.primaryBlue,
      unselectedItemColor: Colors.grey,
      currentIndex: 1, // Home is selected
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'), // [cite: 3508]
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'), // 
        BottomNavigationBarItem(icon: Icon(Icons.error_outline), label: 'Zone Alert'), // [cite: 3509]
      ],
    );
  }
}