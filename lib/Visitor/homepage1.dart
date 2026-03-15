import 'package:flutter/material.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  static const Color kPurple = Color(0xFF867AB9);
  static const Color kDark = Color(0xFF353841);

  final List<String> _destinations = const [
    'Boulevard World',
    'Boulevard City',
    'Riyadh Zoo',
    'Al-Bujari',
  ];

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  String _selected = 'Boulevard World'; // selected place 
  DateTime _lastUpdate = DateTime.now(); // store last update

  bool _showSheet = false; // pottom sheet hide
  Offset? _pinPosition; // store pin position

// function for pottom sheet
  Future<void> _animateSheet(double size) async {
    if (!_sheetController.isAttached) return;
    await _sheetController.animateTo(
      size,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }
// refresh button
  void _refresh() {
    setState(() {
      _lastUpdate = DateTime.now();
    });
  }
// format time 
  String _formattedTime(DateTime dateTime) {
    final hh = dateTime.hour.toString().padLeft(2, '0');
    final mm = dateTime.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  void _showComingSoonDialog(String destination) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: kPurple.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: kPurple,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  destination,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2430),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This destination will be available soon.\nWe are working on adding full details and zone navigation.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: Color.fromARGB(255, 103, 107, 116),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDark,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Got it',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectBoulevardWorldAt(Offset pinPosition) {
    setState(() {
      _selected = 'Boulevard World';
      _showSheet = true;
      _pinPosition = pinPosition;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateSheet(0.34); 
    });
  }
// if we need to add more places 
  void _handleDestinationSelected(String value, BoxConstraints constraints) {
    if (value == 'Boulevard World') {
      final worldRect = _MapRects.boulevardWorld(constraints);
      final pin = Offset(worldRect.center.dx, worldRect.center.dy - 8);
      _selectBoulevardWorldAt(pin);
    } else {
      _showComingSoonDialog(value);
    }
  }
// cleck on map
  void _onMapTap(TapDownDetails details, BoxConstraints constraints) {
    final point = details.localPosition;

    final worldRect = _MapRects.boulevardWorld(constraints);
    final cityRect = _MapRects.boulevardCity(constraints);
    final zooRect = _MapRects.riyadhZoo(constraints);
    final bujariRect = _MapRects.alBujari(constraints);

    if (worldRect.contains(point)) {
      final pin = Offset(worldRect.center.dx, worldRect.center.dy - 8);
      _selectBoulevardWorldAt(pin);
      return;
    }

    if (cityRect.contains(point)) {
      _showComingSoonDialog('Boulevard City');
      return;
    }

    if (zooRect.contains(point)) {
      _showComingSoonDialog('Riyadh Zoo');
      return;
    }

    if (bujariRect.contains(point)) {
      _showComingSoonDialog('Al-Bujari');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) => _onMapTap(details, constraints),
                    child: _MapCanvas(constraints: constraints),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: const Color(0xFFF6EFF8),
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: Icon(
                              Icons.location_on_outlined,
                              color: kPurple,
                              size: 35,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _TopDropdown(
                              value: _selected,
                              items: _destinations,
                              onSelected: (value) =>
                                  _handleDestinationSelected(value, constraints),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 40,
                                child: ElevatedButton.icon(
                                  onPressed: _refresh,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kDark,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    'Refresh',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Last update: ${_formattedTime(_lastUpdate)}',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF7C7E86),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_pinPosition != null)
                    Positioned(
                      left: _pinPosition!.dx - 13,
                      top: _pinPosition!.dy - 30,
                      child: const _PinMarker(),
                    ),
                  _DetailsBottomSheet(
                    controller: _sheetController,
                    visible: _showSheet,
                    onArrowTap: () => _animateSheet(0.18),
                    onClose: () async {
                      await _animateSheet(0.0);
                      if (!mounted) return;
                      setState(() {
                        _showSheet = false;
                        _pinPosition = null;
                      });
                    },
                    onExplore: () {},
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MapRects {
  static Rect boulevardWorld(BoxConstraints c) {
    return Rect.fromLTWH(
      c.maxWidth * 0.61,
      c.maxHeight * 0.48,
      c.maxWidth * 0.23,
      c.maxHeight * 0.18,
    );
  }

  static Rect boulevardCity(BoxConstraints c) {
    return Rect.fromLTWH(
      c.maxWidth * 0.39,
      c.maxHeight * 0.61,
      c.maxWidth * 0.19,
      c.maxHeight * 0.12,
    );
  }

  static Rect riyadhZoo(BoxConstraints c) {
    return Rect.fromLTWH(
      c.maxWidth * 0.08,
      c.maxHeight * 0.50,
      c.maxWidth * 0.24,
      c.maxHeight * 0.17,
    );
  }

  static Rect alBujari(BoxConstraints c) {
    return Rect.fromLTWH(
      c.maxWidth * 0.08,
      c.maxHeight * 0.18,
      c.maxWidth * 0.23,
      c.maxHeight * 0.17,
    );
  }
}

class _TopDropdown extends StatelessWidget {
  const _TopDropdown({
    required this.value,
    required this.items,
    required this.onSelected,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '',
      color: Colors.white,
      elevation: 10,
      offset: const Offset(30, 30),// change here
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return items.map((item) {
          final isSelected = item == value;
          return PopupMenuItem<String>(
            value: item,
            height: 48,
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: isSelected
                      ? const Color(0xFF867AB9)
                      : const Color(0xFFB7B9C0),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFF1F2430),
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        height: 40,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1F2430),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF1F2430),
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapCanvas extends StatelessWidget {
  const _MapCanvas({required this.constraints});

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final worldRect = _MapRects.boulevardWorld(constraints);
    final cityRect = _MapRects.boulevardCity(constraints);
    final zooRect = _MapRects.riyadhZoo(constraints);
    final bujariRect = _MapRects.alBujari(constraints);

    return Container(
      color: const Color(0xFFF2F3F4),
      child: Stack(
        children: [
          CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _RoadPainter(),
          ),
          Positioned.fromRect(
            rect: bujariRect,
            child: const _MapArea(
              color: Color(0xFFF2E5B8),
              borderColor: Color(0xFFE2D39E),
              child: _MapLabel(
                text: 'Al-Bujari',
                textColor: Color(0xFF636A59),
              ),
            ),
          ),
          Positioned(
            left: constraints.maxWidth * 0.55,
            top: constraints.maxHeight * 0.23,
            child: _MapArea(
              width: constraints.maxWidth * 0.22,
              height: constraints.maxHeight * 0.12,
              color: const Color(0xFFDCE9D8),
              borderColor: const Color(0xFFC8D8C2),
              child: const _MapLabel(
                text: 'A Sahamiyah',
                textColor: Color(0xFF5D6E5C),
              ),
            ),
          ),
          Positioned.fromRect(
            rect: zooRect,
            child: const _MapArea(
              color: Color(0xFFDCE9D8),
              borderColor: Color(0xFFC8D8C2),
              child: _MapLabel(
                text: 'Riyadh\nZoo',
                textColor: Color(0xFF5D6E5C),
              ),
            ),
          ),
          Positioned.fromRect(
            rect: cityRect,
            child: const _MapArea(
              color: Color(0xFFDCE9D8),
              borderColor: Color(0xFFC8D8C2),
              child: _MapLabel(
                text: 'Boulevard\nCity',
                textColor: Color(0xFF5D6E5C),
              ),
            ),
          ),
          Positioned.fromRect(
            rect: worldRect,
            child: const _MapArea(
              color: Color(0xFFF4D3D8),
              borderColor: Color(0xFFE8BEC5),
              child: _MapLabel(
                text: 'Boulevard\nWorld',
                textColor: Color(0xFF5D606B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapArea extends StatelessWidget {
  const _MapArea({
    this.width,
    this.height,
    required this.color,
    required this.borderColor,
    required this.child,
  });

  final double? width;
  final double? height;
  final Color color;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BlobShapePainter(
        fillColor: color,
        borderColor: borderColor,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(child: child),
      ),
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({
    required this.text,
    required this.textColor,
  });

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
        height: 1.1,
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _PinMarker extends StatelessWidget {
  const _PinMarker();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.location_on,
      color: Color(0xFFE54545),
      size: 30,
    );
  }
}

class _DetailsBottomSheet extends StatelessWidget {
  const _DetailsBottomSheet({
    required this.controller,
    required this.visible,
    required this.onArrowTap,
    required this.onClose,
    required this.onExplore,
  });

  final DraggableScrollableController controller;
  final bool visible;
  final VoidCallback onArrowTap;
  final VoidCallback onClose;
  final VoidCallback onExplore;

  static const Color kPurple = Color(0xFF867AB9);
  static const Color kDark = Color(0xFF353841);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: visible ? 1 : 0,
        child: DraggableScrollableSheet(
          controller: controller,
          initialChildSize: 0.34,
          minChildSize: 0.18,
          maxChildSize: 0.56,
          snap: true,
          snapSizes: const [0.18, 0.34, 0.56],
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 22,
                    offset: Offset(0, -8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3E5EA),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: onArrowTap,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Color(0xFF52545B),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: const Text(
                          'Boulevard World',
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF1F2430),
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          'Boulevard World is a premier Riyadh Season destination, featuring global cultures, and diverse international dining experiences.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.45,
                            color: Color(0xFF454A57),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          children: [
                            _InfoTile(
                              icon: Icons.location_on_outlined,
                              text: 'Location: Riyadh, Hiteen',
                            ),
                            SizedBox(height: 10),
                            _InfoTile(
                              icon: Icons.access_time_rounded,
                              text: 'Open: 4:00 PM – 12:00 AM',
                            ),
                            SizedBox(height: 10),
                            _InfoTile(
                              icon: Icons.groups_rounded,
                              text: 'Current Visitors: 145',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: onExplore,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kDark,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Explore the Zone',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  static const Color kPurple = Color(0xFF867AB9);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: kPurple),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF1F2430),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final outer = Paint()
      ..color = const Color(0xFFE5E6EA)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 13;

    final inner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    final roads = <Path>[
      Path()
        ..moveTo(size.width * 0.10, size.height * 0.39)
        ..cubicTo(
          size.width * 0.22,
          size.height * 0.22,
          size.width * 0.38,
          size.height * 0.24,
          size.width * 0.52,
          size.height * 0.31,
        )
        ..cubicTo(
          size.width * 0.68,
          size.height * 0.39,
          size.width * 0.76,
          size.height * 0.52,
          size.width * 0.78,
          size.height * 0.67,
        ),
      Path()
        ..moveTo(size.width * 0.40, size.height * 0.21)
        ..cubicTo(
          size.width * 0.44,
          size.height * 0.34,
          size.width * 0.42,
          size.height * 0.48,
          size.width * 0.36,
          size.height * 0.58,
        )
        ..cubicTo(
          size.width * 0.31,
          size.height * 0.66,
          size.width * 0.28,
          size.height * 0.74,
          size.width * 0.22,
          size.height * 0.83,
        ),
      Path()
        ..moveTo(size.width * 0.44, size.height * 0.71)
        ..cubicTo(
          size.width * 0.54,
          size.height * 0.66,
          size.width * 0.66,
          size.height * 0.64,
          size.width * 0.79,
          size.height * 0.69,
        ),
    ];

    for (final path in roads) {
      canvas.drawPath(path, outer);
      canvas.drawPath(path, inner);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BlobShapePainter extends CustomPainter {
  _BlobShapePainter({
    required this.fillColor,
    required this.borderColor,
  });

  final Color fillColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = fillColor;
    final border = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.16)
      ..quadraticBezierTo(
        size.width * 0.18,
        size.height * 0.02,
        size.width * 0.44,
        size.height * 0.06,
      )
      ..quadraticBezierTo(
        size.width * 0.84,
        size.height * 0.02,
        size.width * 0.90,
        size.height * 0.30,
      )
      ..quadraticBezierTo(
        size.width * 0.98,
        size.height * 0.68,
        size.width * 0.78,
        size.height * 0.90,
      )
      ..quadraticBezierTo(
        size.width * 0.42,
        size.height * 1.02,
        size.width * 0.18,
        size.height * 0.86,
      )
      ..quadraticBezierTo(
        size.width * 0.02,
        size.height * 0.64,
        size.width * 0.12,
        size.height * 0.16,
      )
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(covariant _BlobShapePainter oldDelegate) {
    return oldDelegate.fillColor != fillColor ||
        oldDelegate.borderColor != borderColor;
  }
}