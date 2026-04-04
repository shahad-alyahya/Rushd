import 'package:flutter/material.dart';
import 'ZoneAlerts-1.dart';

class ZoneAlerts2Screen extends StatelessWidget {
  const ZoneAlerts2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      bottomNavigationBar: Container(
        height: 78,
        padding: const EdgeInsets.only(left: 28, right: 28, top: 8, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomItemResponded(
              icon: Icons.person_outline,
              label: 'Profile',
              selected: false,
            ),
            BottomItemResponded(
              icon: Icons.home_outlined,
              label: 'Home',
              selected: false,
            ),
            BottomItemResponded(
              icon: Icons.info_outline,
              label: 'Zone Alert',
              selected: true,
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 401,
            height: 874,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),

                  SizedBox(
                    height: 24,
                    child: Row(
                      children: [
                        const Text(
                          '9:41',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF010E16),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.signal_cellular_alt,
                          size: 15,
                          color: Color(0xFF010E16),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.wifi,
                          size: 15,
                          color: Color(0xFF010E16),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 24,
                          height: 11,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF010E16),
                              width: 1.3,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 15,
                              margin: const EdgeInsets.all(1.1),
                              decoration: BoxDecoration(
                                color: const Color(0xFF010E16),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Zone Alerts',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Center(
                    child: Container(
                      width: 280,
                      height: 46,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Center(
                                child: Text(
                                  'Active Alerts',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF9B9B9B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x12000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'Responded Alerts',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF4A5660),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: const [
                        AlertCardResponded(
                          imagePath: 'assets/images/egypt.png',
                          title: 'Egyptian Subzone',
                          date: '19 Des 2025',
                          timeAgo: '40 minutes ago',
                          levelText: 'Low Level',
                          levelBg: Color(0x334CAF50),
                          levelTextColor: Color(0xFF2E7D32),
                        ),
                        SizedBox(height: 20),
                        AlertCardResponded(
                          imagePath: 'assets/images/japan.png',
                          title: 'Japanese Subzone',
                          date: '5 Des 2025',
                          timeAgo: '34 minutes ago',
                          levelText: 'Low Level',
                          levelBg: Color(0x334CAF50),
                          levelTextColor: Color(0xFF2E7D32),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlertCardResponded extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String timeAgo;
  final String levelText;
  final Color levelBg;
  final Color levelTextColor;

  const AlertCardResponded({
    super.key,
    required this.imagePath,
    required this.title,
    required this.date,
    required this.timeAgo,
    required this.levelText,
    required this.levelBg,
    required this.levelTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              imagePath,
              width: 122,
              height: 86,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Color(0xFF4A5660),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9B9B9B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(0xFF4A5660),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9B9B9B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: levelBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        levelText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: levelTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomItemResponded extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const BottomItemResponded({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFF867AB9);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 22,
          color: selected ? activeColor : const Color(0xFF010E16),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: selected ? activeColor : const Color(0xFF010E16),
          ),
        ),
      ],
    );
  }
}