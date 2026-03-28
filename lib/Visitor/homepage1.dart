import 'package:flutter/material.dart';
// Comment for this page 
//1- Change the discreption of Bottom Sheet to be Dinamic for choosen places -> take it from database or real time data (i'm not sure)
//2- كتبت الكود بحيث لما يضغط على كلمه بوليفارد من الليست يطلع له الشييت  فقط حتى اشوفه واعدله لكن شيليه وانه يطلع فقط لما يضغط عالخريطة
//3- في هولدر تحت للخريطه لكن ممكن يحتاج كود اضافي غير هالمكان للدبوس الخريطة او غيره تأكدي من هالشي 
//4- Do not add bottom bar for this page 
// 5- add in button (explore the zone) -> to route page according to the choosen plase & updated
//6- for the current visitors -> need data from database 
// 7- need the map to be zoom out 
// 8- للخريطه ترى بس البوليفارد بتكون لها الوان حسب زحمتها لكن للاماكن الثانيه اللي بالليست تكون محدده بس بدون لون ولباقي الاماكن بالخريطه تكون رمادي 

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

  String _selected = 'Boulevard World';
  DateTime _lastUpdate = DateTime.now();
  bool _showSheet = false;

  Future<void> _animateSheet(double size) async {
    if (!_sheetController.isAttached) return;
    await _sheetController.animateTo(
      size,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _refresh() {
    setState(() {
      _lastUpdate = DateTime.now();
    });
  }

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

  Future<void> _handleDestinationSelected(String value) async {
    setState(() {
      _selected = value;
    });

    if (value == 'Boulevard World') {
      setState(() {
        _showSheet = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animateSheet(0.36);
      });
    } else {
      setState(() {
        _showSheet = false;
      });
      _showComingSoonDialog(value);
    }
  }

  Future<void> _closeSheet() async {
    await _animateSheet(0.0);
    if (!mounted) return;

    setState(() {
      _showSheet = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: const Color(0xFFF2F3F4),

                // ==================================================
                // PLACE MAP HERE
                // ==================================================
                child: const Center(
                  child: Text(
                    ' Map will be added here',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7C7E86),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 12,
              left: 12,
              right: 12,
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
                        onSelected: _handleDestinationSelected,
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

            _DetailsBottomSheet(
              controller: _sheetController,
              visible: _showSheet,
              onClose: _closeSheet,
              onExplore: () {},
            ),
          ],
        ),
      ),
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
      offset: const Offset(-8, 40),
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
      child: SizedBox(
        height: 40,
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
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF1F2430),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsBottomSheet extends StatelessWidget {
  const _DetailsBottomSheet({
    required this.controller,
    required this.visible,
    required this.onClose,
    required this.onExplore,
  });

  final DraggableScrollableController controller;
  final bool visible;
  final VoidCallback onClose;
  final VoidCallback onExplore;

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
          initialChildSize: 0.36,
          minChildSize: 0.36,
          maxChildSize: 0.60,
          snap: true,
          snapSizes: const [0.36, 0.60],
          builder: (context, scrollController) {
            return Container(
              width: double.infinity,
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
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: onClose,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF52545B),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Boulevard World',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF1F2430),
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Boulevard World is a premier Riyadh Season destination, featuring global cultures, and diverse international dining experiences.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Color(0xFF454A57),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Column(
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