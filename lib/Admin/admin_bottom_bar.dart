import 'package:flutter/material.dart';

import 'HomePage-3.dart'; 
import 'ZonesListPage.dart'; 
import 'security_Staff_List.dart'; 

class AdminBottomBar extends StatelessWidget {
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
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (isActive) return;

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
          color: isActive ? const Color(0xFFDEDAF4) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 28,
          color: Colors.black, 
        ),
      ),
    );
  }
}
