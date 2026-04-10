import 'package:flutter/material.dart';
import 'package:rushd/Visitor/homepage1.dart';
// import other pages

// Add other pages that the bottom bar needs to access
// فيه ايرور لان ما حطيت الميثودز حقت الصفحات الباقية ولا امبورت

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomBar({super.key, required this.currentIndex});

  static const Color kPurple = Color(0xFF867AB9);
  static const Color kGrey = Colors.black54;

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget page;

    switch (index) {
      case 0:
        //  page = const ProfilePage();
        break;
      case 1:
        page = const HomePage1();
        break;
      case 2:
        // page = const RoutesPage();
        break;
      default:
        page = const HomePage1();
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 78,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(
              context: context,
              index: 0,
              icon: Icons.person_outline,
              label: 'Profile',
            ),
            _buildItem(
              context: context,
              index: 1,
              icon: Icons.home_outlined,
              label: 'Home',
            ),
            _buildItem(
              context: context,
              index: 2,
              icon: Icons.map_outlined,
              label: 'Route',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(context, index),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: isSelected ? kPurple : kGrey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? kPurple : kGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
