import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:rushd/map/riyadh_season_map.dart';
import 'package:rushd/map/testAreaPage.dart';
import 'package:rushd/map/test_area_preview_map.dart';
import 'package:rushd/reading_listener.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();

}

class _HomePage1State extends State<HomePage1> {
  static const Color kPurple = Color(0xFF867AB9);
  static const Color kDark = Color(0xFF353841);
  @override
  // Starts the sensor reading listener.
void initState() {
  super.initState();
  ReadingListener().startListening();
}
  final Map<String, Map<String, dynamic>> placeData = {
    'Boulevard World': {
      'description':
          'Boulevard World is a premier Riyadh Season destination, featuring global cultures, and diverse international dining experiences.',
      'visitors': 145,
    },
    'Test Area': {
      'description': 'Test Area for route and map testing.',
      'visitors': 40,
    },
    'Boulevard City': {
      'description':
          'Boulevard City offers a modern entertainment experience with attractions, events, and dining options.',
      'visitors': 90,
    },
    'Riyadh Zoo': {
      'description':
          'Riyadh Zoo is a family-friendly attraction with a variety of animals and outdoor experiences.',
      'visitors': 60,
    },
    'Al-Bujari': {
      'description':
          'Al-Bujari is known for its heritage vibe, restaurants, and relaxing atmosphere.',
      'visitors': 40,
    },
  };

  final List<String> _destinations = const [
    'Boulevard World',
    'Test Area',
    'Boulevard City',
    'Riyadh Zoo',
    'Al-Bujari',
  ];

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  String _selected = 'Boulevard World';
  DateTime _lastUpdate = DateTime.now();
  bool _showSheet = true;
// Animates the bottom sheet.
  Future<void> _animateSheet(double size) async {
    if (!_sheetController.isAttached) return;
    await _sheetController.animateTo(
      size,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }
// Updates the refresh time.
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
// Handles selected destination.
  Future<void> _handleDestinationSelected(String value) async {
    setState(() {
      _selected = value;
    });

    if (value == 'Boulevard World' || value == 'Test Area') {
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$value will be available soon'),
          backgroundColor: Colors.grey.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
// Closes the details sheet.
  Future<void> _closeSheet() async {
    await _animateSheet(0.0);
    if (!mounted) return;

    setState(() {
      _showSheet = false;
    });
  }
// Builds the home page screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380,
            child: Stack(
              children: [
                Positioned.fill(
                  child: _selected == 'Test Area'
                      ? const TestAreaPreviewMap()
                      : const RiyadhSeasonMapView(),
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
                            onSelected: _handleDestinationSelected,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
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
                        ),
                      ],
                    ),
                  ),
                ),
                _DetailsBottomSheet(
                  controller: _sheetController,
                  visible: _showSheet,
                  onClose: _closeSheet,
                  onExplore: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                     builder: (context) => RoutesPage(
                      selectedLocation: _selected,
                         ),
                      ),
                    );
                  },
                  selected: _selected,
                  placeData: placeData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Dropdown menu for destination selection.
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
// Bottom sheet displaying place details.
class _DetailsBottomSheet extends StatelessWidget {
  const _DetailsBottomSheet({
    required this.controller,
    required this.visible,
    required this.onClose,
    required this.onExplore,
    required this.selected,
    required this.placeData,
  });

  final DraggableScrollableController controller;
  final bool visible;
  final VoidCallback onClose;
  final VoidCallback onExplore;
  final String selected;
  final Map<String, Map<String, dynamic>> placeData;

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
                      Text(
                        selected,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Color(0xFF1F2430),
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        placeData[selected]?['description'] ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Color(0xFF454A57),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Column(
                        children: [
                          const _InfoTile(
                            icon: Icons.location_on_outlined,
                            text: 'Location: Riyadh, Hiteen',
                          ),
                          const SizedBox(height: 10),
                          const _InfoTile(
                            icon: Icons.access_time_rounded,
                            text: 'Open: 4:00 PM – 12:00 AM',
                          ),
                          const SizedBox(height: 10),
                          _InfoTile(
                            icon: Icons.groups_rounded,
                            text:
                                'Current Visitors: ${placeData[selected]?['visitors'] ?? 0}',
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
// Info tile for displaying location details.
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