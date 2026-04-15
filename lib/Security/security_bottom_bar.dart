import 'package:flutter/material.dart';
// Standardize your imports here
import 'home_page2.dart';
import '../SecurityStaff/ZoneAlerts-1.dart';
import 'profile_2.dart'; // Ensure this file name matches your profile file

class SecurityBottomBar extends StatelessWidget {
  final int currentIndex;

  const SecurityBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
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
          // Optimization: If already on the active tab, prevent redundant navigation
          if (index == currentIndex) return;

          Widget nextPage;

          // Index 0: Profile Page
          if (index == 0) {
            nextPage = const SecurityProfilePage();
          }
          // Index 1: Home Dashboard
          else if (index == 1) {
            nextPage = const SecurityDashboardPage();
          }
          // Index 2: Security Alerts
          else if (index == 2) {
            nextPage = const ZoneAlerts1Screen();
          } else {
            return;
          }

          // Execution: Seamless transition to the target screen
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => nextPage,
              transitionDuration:
                  Duration.zero, // Instant swap for professional feel
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
