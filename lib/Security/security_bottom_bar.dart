import 'package:flutter/material.dart';
import 'home_page2.dart';
import '../SecurityStaff/ZoneAlerts-1.dart';
import 'profile_2.dart';

class SecurityBottomBar extends StatelessWidget {
  final int currentIndex;
  final String locationId;

  const SecurityBottomBar({
    super.key,
    required this.currentIndex,
    required this.locationId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;

          Widget nextPage;

          if (index == 0) {
            nextPage = SecurityProfilePage(locationId: locationId);
          } else if (index == 1) {
            nextPage = SecurityDashboardPage();
          } else if (index == 2) {
            nextPage = ZoneAlerts1Screen(locationId: locationId);
          } else {
            return;
          }

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => nextPage,
              transitionDuration: Duration.zero,
            ),
          );
        },
        selectedItemColor: const Color(0xFF867AB9),
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_rounded),
            label: 'Zone Alert',
          ),
        ],
      ),
    );
  }
}