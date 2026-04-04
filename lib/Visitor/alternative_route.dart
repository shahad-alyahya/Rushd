import 'package:flutter/material.dart';

class AlternativeRoute extends StatelessWidget {
  const AlternativeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          // ===== HEADER =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [

                const SizedBox(height: 44),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Transform.translate(
                      offset: const Offset(-6, 0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.location_on,
                            size: 26,
                            color: Color(0xFF867AB9),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Boulevard World",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text("Refresh"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF353841),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 28),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 0),

                        const Text(
                          "Last update: 9:12",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
         const SizedBox(height: 18),
          // ===== MAP + CARD =====
          Expanded(
            child: Stack(
              children: [

                // MAP PLACEHOLDER
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color.fromARGB(255, 247, 247, 247),
                ),

                // CARD
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(90),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Center(child: Container(
                            width: 100,
                            height: 9,
                            decoration: BoxDecoration(
                              color: const Color(0x80B2B2B2),
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Morocco Zone",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.normal,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Row(
                          children: [
                            Icon(Icons.location_on, size: 28),
                            SizedBox(width: 10),
                            Text(
                              "Boulevard World",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        const Row(
                          children: [
                            Icon(Icons.directions_walk,size: 28),
                            SizedBox(width: 10),
                            Text(
                              "Distance: 320 m",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        const Row(
                          children: [
                            Icon(Icons.access_time,size: 28),
                            SizedBox(width: 10),
                            Text(
                              "Estimated time: 4 min",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        Center(
                          child: Container(
                            width: 163,
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF8A8A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "exit",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}