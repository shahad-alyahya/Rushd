import 'package:flutter/material.dart';
import 'package:rushd/map/map_view.dart';
import 'security_bottom_bar.dart';

class SecurityDashboardPage extends StatefulWidget {
  const SecurityDashboardPage({super.key});

  @override
  State<SecurityDashboardPage> createState() => _SecurityDashboardPageState();
}

class _SecurityDashboardPageState extends State<SecurityDashboardPage> {
  String lastUpdate = "9:12"; // Dynamic update state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380, // iPhone shape constraint
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 25),
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
                        _buildHighLevelZoneCard(
                          'Saudi Arabia Zone',
                          '4 minutes ago',
                        ),
                        _buildMediumLevelZoneCard(
                          'Turkey Zone',
                          '12 minutes ago',
                        ),
                        _buildLowLevelZoneCard(
                          'Japanese Zone',
                          '6 minutes ago',
                        ),
                        _buildLowLevelZoneCard(
                          'Greek Subzone',
                          '5 minutes ago',
                        ),
                      ],
                    ),
                  ),
                ),
                // Home index is 1
                const SecurityBottomBar(currentIndex: 1),
              ],
            ),
          ),
        ),
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
            // Logic to refresh data and update timestamp
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
        child: const MapView(mode: MapMode.viewOnly),
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
