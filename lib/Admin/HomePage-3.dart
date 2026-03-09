import 'package:flutter/material.dart';

class HomePage3Screen extends StatelessWidget {
  const HomePage3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 401,
          height: 874,
          child: Stack(
            children: [
              const Positioned(
                left: 28,
                top: 34,
                child: Text(
                  '9:41',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF010E16),
                  ),
                ),
              ),

              const Positioned(
                right: 70,
                top: 34,
                child: Icon(
                  Icons.signal_cellular_alt,
                  size: 15,
                  color: Color(0xFF010E16),
                ),
              ),

              const Positioned(
                right: 50,
                top: 34,
                child: Icon(
                  Icons.wifi,
                  size: 15,
                  color: Color(0xFF010E16),
                ),
              ),

              Positioned(
                right: 20,
                top: 36,
                child: Container(
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
                      margin: const EdgeInsets.all(1.2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF010E16),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),

              const Positioned(
                left: 22,
                top: 74,
                child: Text(
                  'Hi Admin!',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF010E16),
                  ),
                ),
              ),

              const Positioned(
                left: 22,
                top: 104,
                child: Text(
                  'Welcome to your panel.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF969696),
                  ),
                ),
              ),

              const Positioned(
                right: 24,
                top: 82,
                child: Icon(
                  Icons.logout,
                  size: 24,
                  color: Color(0xFFA61A22),
                ),
              ),

              Positioned(
                left: 0,
                top: 134,
                child: Container(
                  width: 401,
                  height: 238,
                  color: const Color(0x4D867AB9),
                ),
              ),

              Positioned(
                left: 22,
                top: 150,
                child: _Card(
                  357,
                  75,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Visitors",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF010E16),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "7,783",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF010E16),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 22,
                top: 245,
                child: _Card(
                  171,
                  101,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/security.png",
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Security",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF010E16),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "4,120",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF010E16),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 208,
                top: 245,
                child: _Card(
                  171,
                  101,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Image.asset(
                       "assets/images/map.png",
                       width: 24,
                       height: 24,
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Zones",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF010E16),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "87",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF010E16),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 22,
                top: 380,
                child: Container(
                  width: 357,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _SegmentButton(
                        label: 'Daily',
                        selected: true,
                      ),
                      SizedBox(width: 10),
                      _SegmentButton(
                        label: 'Monthly',
                        selected: false,
                      ),
                      SizedBox(width: 10),
                      _SegmentButton(
                        label: 'Year',
                        selected: false,
                      ),
                    ],
                  ),
                ),
              ),

              const Positioned(
                left: 27,
                top: 480,
                child: Text(
                  'Select Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF010E16),
                  ),
                ),
              ),

              Positioned(
                left: 27,
                top: 505,
                child: _InputBox(
                  width: 222,
                  height: 41,
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Boulevard World',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF010E16),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: Color(0xFF010E16),
                      ),
                    ],
                  ),
                ),
              ),

              const Positioned(
                left: 27,
                top: 565,
                child: Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF010E16),
                  ),
                ),
              ),

              Positioned(
                left: 27,
                top: 590,
                child: _InputBox(
                  width: 222,
                  height: 41,
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          '15 October 2025',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF010E16),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        size: 20,
                        color: Color(0xFF010E16),
                      ),
                    ],
                    ),
                ),
              ),

              const Positioned(
                left: 320,
                top: 624,
                child: Icon(
                  Icons.ios_share_outlined,
                  size: 25,
                  color: Color(0xFF010E16),
                ),
              ),

              const Positioned(
                left: 352,
                top: 624,
                child: Icon(
                  Icons.print,
                  size: 25,
                  color: Color(0xFF010E16),
                ),
              ),

              Positioned(
                left: 86,
                top: 784,
                child: Container(
                  width: 229,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/images/security.png",
                        width: 22,
                        height: 22,
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xA8B1AFD0),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.home,
                          size: 20,
                          color: Color(0xFF010E16),
                        ),
                      ),
                     Image.asset(
                       "assets/images/map.png",
                       width: 24,
                       height: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final double w;
  final double h;
  final Widget child;

  const _Card(this.w, this.h, this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool selected;

  const _SegmentButton({
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
        color: selected
            ? const Color(0x99867AB9)
            : const Color(0x33867AB9),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF010E16),
          ),
        ),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const _InputBox({
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}