import 'package:flutter/material.dart';
import 'package:rushd/map/map_view.dart';

class SecurityDashboardPage extends StatefulWidget {
  const SecurityDashboardPage({super.key});

  @override
  State<SecurityDashboardPage> createState() => _SecurityDashboardPageState();
}

class _SecurityDashboardPageState extends State<SecurityDashboardPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildMapPlaceholder(),
              const SizedBox(height: 25),
              const Text(
                'Real-Time Status of all Zons',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              // الحالات الثلاث للمناطق
              _buildHighLevelZoneCard('Saudi Arabia Zone', '4 minutes ago'),
              _buildMediumLevelZoneCard('Turkey Zone', '12 minutes ago'),
              _buildLowLevelZoneCard('Japanese Zone', '6 minutes ago'),
              _buildLowLevelZoneCard('Greek Subzone', '5 minutes ago'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Securty Dashboard',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              'Last update: 9:12',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.refresh, color: Colors.black),
          label: const Text('Refresh', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget _buildMapPlaceholder() {
  return Container(
    height: 250,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 10),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: const MapView(
        mode: MapMode.viewOnly,
      ),
    ),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5),
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                timeAgo,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                fontSize: 12,
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

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (i) => setState(() => _selectedIndex = i),
      selectedItemColor: const Color(0xFF673AB7),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.report_problem_outlined),
          label: 'Zone Alert',
        ),
      ],
    );
  }
}
