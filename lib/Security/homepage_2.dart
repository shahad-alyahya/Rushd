import 'package:flutter/material.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  // Navigation index for Bottom Bar
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Section (Title & Refresh)
              _buildHeaderSection(),

              const SizedBox(height: 16),

              // 2. Map Placeholder (Empty Box)
              _buildMapPlaceholderSection(),

              const SizedBox(height: 24),

              // 3. Status Subtitle
              const Text(
                'Real-Time Status of all Zones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff5C5E69),
                ),
              ),

              const SizedBox(height: 12),

              // 4. Zone Cards List
              _buildZoneCard(
                zoneName: 'Saudi Arabia Zone',
                timeAgo: '4 minutes ago',
                level: 'High Level',
                levelColor: Colors.red,
              ),

              _buildZoneCard(
                zoneName: 'Turkey Zone',
                timeAgo: '12 minutes ago',
                level: 'Medium Level',
                levelColor: Colors.orange,
              ),

              _buildZoneCard(
                zoneName: 'Japanese Zone',
                timeAgo: '6 minutes ago',
                level: 'Low Level',
                levelColor: Colors.green,
              ),

              _buildZoneCard(
                zoneName: 'Greek Subzone',
                timeAgo: '5 minutes ago',
                level: 'Low Level',
                levelColor: Colors.green,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- UI Methods ---

  // Method for Title and Refresh Button
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Security Dashboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xff1F2230),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Last update: 9:12',
              style: TextStyle(fontSize: 14, color: Color(0xff8F92B2)),
            ),
            Row(
              children: [
                const Icon(Icons.refresh, size: 20, color: Color(0xff313444)),
                const SizedBox(width: 4),
                const Text(
                  'Refresh',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff313444),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Method for the Empty Map Box
  Widget _buildMapPlaceholderSection() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffECECF2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 40, color: Color(0xffA5A7B3)),
            SizedBox(height: 8),
            Text(
              'Map Integration Placeholder',
              style: TextStyle(color: Color(0xffA5A7B3)),
            ),
          ],
        ),
      ),
    );
  }

  // REUSABLE METHOD: This is the one that was missing in your screenshot
  Widget _buildZoneCard({
    required String zoneName,
    required String timeAgo,
    required String level,
    required Color levelColor,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xffECECF2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: Color(0xff313444),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zoneName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1F2230),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff8F92B2),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: levelColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                level,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: levelColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Navigation Bar Method
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.error_outline),
          label: 'Zone Alert',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0xff313444),
      unselectedItemColor: const Color(0xffA5A7B3),
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      elevation: 10,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    );
  }
}
