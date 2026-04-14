import 'package:flutter/material.dart';

// --- Global Administrative Route Imports ---
// Importing all dashboard modules to enable centralized navigation
import 'HomePage-3.dart'; // Admin Home
import 'ZonesListPage.dart'; // Zones Management
import 'security_Staff_List.dart'; // Security Staff Management

/// [AdminBottomBar] serves as the primary navigation engine for the Admin panel.
/// It implements a floating stadium-design with instant state-switching.
class AdminBottomBar extends StatelessWidget {
  final int currentIndex;

  const AdminBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Strategic margins to maintain the "Floating" UI aesthetic on all devices
      margin: const EdgeInsets.only(bottom: 25, left: 40, right: 40),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Index 0: Left Icon - Security Staff Registry
          _buildNavItem(
            context,
            0,
            Icons.badge_outlined,
            const SecurityStaffList(),
          ),

          // Index 1: Middle Icon - Central Admin Dashboard (Home)
          _buildNavItem(context, 1, Icons.home_filled, const AdminHomePage()),

          // Index 2: Right Icon - Zone Monitoring & List
          _buildNavItem(
            context,
            2,
            Icons.location_on_outlined,
            const ZonesListPage(),
          ),
        ],
      ),
    );
  }

  /// [_buildNavItem] constructs a context-aware navigation node.
  /// It utilizes 'pushReplacement' to optimize memory and maintain a clean back-stack.
  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    Widget destination,
  ) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () {
        // Prevention logic: Stop redundant navigation if the target is already active
        if (isActive) return;

        // Executing high-performance navigation with zero latency
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => destination,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // Visual feedback for the active navigation node
          color: isActive ? const Color(0xFFDEDAF4) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 28,
          color: Colors.black, // High-contrast icons for accessibility
        ),
      ),
    );
  }
}
