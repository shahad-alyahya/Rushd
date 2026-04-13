import 'package:flutter/material.dart';
import 'package:rushd/map/map_view.dart';
// Importing the custom bottom bar for security module
import 'security_bottom_bar.dart';

class SecurityDashboardPage extends StatefulWidget {
  const SecurityDashboardPage({super.key});

  @override
  State<SecurityDashboardPage> createState() => _SecurityDashboardPageState();
}

class _SecurityDashboardPageState extends State<SecurityDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            // Constraints the width to maintain a consistent iPhone-like look
            width: 380,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    // Smooth iOS-style bounce effect
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 25),

                        // Map Section with shadow and rounded corners
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

                        // Zone status cards showing different threat levels
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

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                // Reusable Bottom Bar fixed at the bottom of the screen
                const SecurityBottomBar(currentIndex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header section with responsive layout to prevent overflow
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Using Expanded to ensure text doesn't push the refresh button off-screen
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Security Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                // Truncate long text with ellipsis to maintain layout integrity
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Last update: 9:12',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        // Refresh button for fetching latest status updates
        TextButton.icon(
          onPressed: () {
            // TODO: Implement refresh logic here
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

  // Interactive or View-Only Map integration
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

  // Core builder for zone alert cards
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
          // Dynamic status badge
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

  // Specialized card for High Alert (Red)
  Widget _buildHighLevelZoneCard(String name, String time) => _buildZoneCard(
    zoneName: name,
    timeAgo: time,
    levelText: 'High Level',
    levelColor: const Color(0xFFFFEAEA),
    levelTextColor: const Color(0xFFEF5350),
  );

  // Specialized card for Medium Alert (Orange)
  Widget _buildMediumLevelZoneCard(String name, String time) => _buildZoneCard(
    zoneName: name,
    timeAgo: time,
    levelText: 'Medium Level',
    levelColor: const Color(0xFFFFF3E0),
    levelTextColor: const Color(0xFFFF9800),
  );

  // Specialized card for Low/Safe Alert (Green)
  Widget _buildLowLevelZoneCard(String name, String time) => _buildZoneCard(
    zoneName: name,
    timeAgo: time,
    levelText: 'Low Level',
    levelColor: const Color(0xFFE8F5E9),
    levelTextColor: const Color(0xFF66BB6A),
  );
}
