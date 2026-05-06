import 'package:flutter/material.dart';

import 'HomePage-3.dart';
import 'ZonesListPage.dart';
import 'security_Staff_List.dart';

// Custom bottom navigation bar for the Admin interface
class AdminBottomBar extends StatelessWidget {
  // index of the currently active tab
  final int currentIndex;

  const AdminBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25, left: 40, right: 40),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          // Subtle shadow to give a "floating" effect
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
          // Navigation items for Security, Home, and Zones
          _buildNavItem(
            context,
            0,
            Icons.badge_outlined,
            const SecurityStaffList(),
          ),

          _buildNavItem(context, 1, Icons.home_filled, const AdminHomePage()),

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

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    Widget destination,
  ) {
    // Check if this item is the one currently selected
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () {
        // Do nothing if we are already on this page
        if (isActive) return;
        // Navigate to the destination page
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
          // Highlight the active icon with a circular background
          color: isActive ? const Color(0xFFDEDAF4) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 28, color: Colors.black),
      ),
    );
  }
}
