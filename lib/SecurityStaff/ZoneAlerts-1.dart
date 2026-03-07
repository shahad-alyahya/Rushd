import 'package:flutter/material.dart';

class ZoneAlerts1Screen extends StatelessWidget {
  const ZoneAlerts1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Zone Alerts',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
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
                                'Active Alerts',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Responded Alerts',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFB6B6B6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: ListView(
                      children: const [
                        AlertCard(
                          imagePath: 'assets/images/saudiZone.png',
                          title: 'Saudi Arabia Zone',
                          date: '27 Des 2025',
                          timeAgo: '4 minutes ago',
                          levelText: 'High Level',
                          levelBg: Color(0xFFF8D5D8),
                          levelTextColor: Color(0xFFE17884),
                        ),
                        SizedBox(height: 20),
                        AlertCard(
                          imagePath: 'assets/images/AmusementPark.png',
                          title: 'Amusement Park',
                          date: '27 Des 2025',
                          timeAgo: '8 minutes ago',
                          levelText: 'Medium Level',
                          levelBg: Color(0xFFFFE4CC),
                          levelTextColor: Color(0xFFE8A15F),
                        ),
                        SizedBox(height: 20),
                        AlertCard(
                          imagePath: 'assets/images/greek.png',
                          title: 'Greek Subzone',
                          date: '27 Des 2025',
                          timeAgo: '14 minutes ago',
                          levelText: 'Medium Level',
                          levelBg: Color(0xFFFFE4CC),
                          levelTextColor: Color(0xFFE8A15F),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 72,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BottomItem(
                          icon: Icons.person_outline,
                          label: 'Profile',
                          selected: false,
                        ),
                        BottomItem(
                          icon: Icons.home_outlined,
                          label: 'Home',
                          selected: false,
                        ),
                        BottomItem(
                          icon: Icons.info_outline,
                          label: 'Zone Alert',
                          selected: true,
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

class AlertCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String timeAgo;
  final String levelText;
  final Color levelBg;
  final Color levelTextColor;

  const AlertCard({
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              imagePath,
              width: 110,
              height: 85,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey,
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
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: levelBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        levelText,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: levelTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const BottomItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFFB9A7E8);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 23,
          color: selected ? activeColor : Colors.black87,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: selected ? activeColor : Colors.black87,
          ),
        ),
      ],
    );
  }
}