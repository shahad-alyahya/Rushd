import 'package:flutter/material.dart';

class ZoneAlerts2Screen extends StatelessWidget {
  const ZoneAlerts2Screen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 10),

                  const Text(
                    'Zone Alerts',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
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

                        const Expanded(
                          child: Center(
                            child: Text(
                              'Active Alerts',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Center(
                              child: Text(
                                'Responded Alerts',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Expanded(
                    child: ListView(
                      children: const [

                        RespondedCard(
                          imagePath: 'assets/images/egypt.png',
                          title: 'Egyptian Subzone',
                          date: '19 Des 2025',
                          timeAgo: '40 minutes ago',
                        ),

                        SizedBox(height: 20),

                        RespondedCard(
                          imagePath: 'assets/images/japan.png',
                          title: 'Japanese Subzone',
                          date: '5 Des 2025',
                          timeAgo: '34 minutes ago',
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    height: 90,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
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

class RespondedCard extends StatelessWidget {

  final String imagePath;
  final String title;
  final String date;
  final String timeAgo;

  const RespondedCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.date,
    required this.timeAgo,
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
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              imagePath,
              width: 120,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,size:14,color:Colors.grey),
                    const SizedBox(width:6),
                    Text(date,style: const TextStyle(fontSize:12,color:Colors.grey)),
                  ],
                ),

                const SizedBox(height:6),

                Row(
                  children: [
                    const Icon(Icons.access_time,size:14,color:Colors.grey),
                    const SizedBox(width:6),
                    Text(timeAgo,style: const TextStyle(fontSize:12,color:Colors.grey)),
                  ],
                ),

                const SizedBox(height:10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal:12,vertical:5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9F2E3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        "Low Level",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2E9B5F),
                          fontWeight: FontWeight.w600,
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
          size: 24,
          color: selected ? activeColor : Colors.grey,
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? activeColor : Colors.grey,
          ),
        ),

      ],
    );
  }
}