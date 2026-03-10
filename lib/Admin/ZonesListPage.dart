import 'package:flutter/material.dart';
import'package:rushd/Admin/AddZonePage.dart';

class ZonesListPage extends StatefulWidget {
  const ZonesListPage({super.key});

  @override
  State<ZonesListPage> createState() => _ZonesListPageState();
}

class _ZonesListPageState extends State<ZonesListPage> {
  static const Color kPurple = Color(0xFF867AB9);
  static const Color kDark = Color(0xFF1F2430);
  static const Color kCard = Color(0xFFF1F1F1);
  static const Color kDelete = Color(0xFF9B4A4A);

  final List<String> _locations = const [
    'Boulevard World',
    'Boulevard City',
    'Al-Bujairi',
    'Riyadh Zoo',
  ];

  String _selectedLocation = 'Boulevard World';
  bool _hasData = true;

  Future<void> _showActionDialog(String title, String message) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDark,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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

  Future<void> _showDeleteDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure you want to delete this Zone?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              ),
                          ),
                          child: const Text(
                            'NO',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Zone deleted successfully'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kDark,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'YES',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onLocationChanged(String? value) {
  if (value == null) return;

  final hasData = _zones.any((zone) => zone['location'] == value);

  setState(() {
    _selectedLocation = value;
    _hasData = hasData;
  });

  if (!hasData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No data available for $value'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

  Widget _buildTopBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLocation,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                borderRadius: BorderRadius.circular(16),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                items: _locations
                    .map(
                      (location) => DropdownMenuItem<String>(
                        value: location,
                        child: Text(location),
                      ),
                    )
                    .toList(),
                onChanged: _onLocationChanged,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _ActionIconButton(
          icon: Icons.ios_share_outlined,
          onTap: () {
            _showActionDialog(
              'Export',
              _hasData
                  ? 'The export action will be connected later.'//here add the export or print func
                  : 'There is no data to export for this location.',
            );
          },
        ),
        const SizedBox(width: 8),
        _ActionIconButton(icon: Icons.print_outlined,
          onTap: () {
            _showActionDialog(
              'Print',
              _hasData
                  ? 'The print action will be connected later.'
                  : 'There is no data to print for this location.',
            );
          },
        ),
      ],
    );
  }

  Widget _buildZoneCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Türkiye Zone',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          InkWell(
            onTap: _showDeleteDialog,
            borderRadius: BorderRadius.circular(30),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 28,
                color: kDelete,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: const [
          Icon(
            Icons.location_off_outlined,
            size: 34,
            color: Colors.black54,
          ),
          SizedBox(height: 10),
          Text(
            'No data available for this location',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

Future<void> _openAddZonePage() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddZonePage(
        selectedLocation: _selectedLocation,
      ),
    ),
  );

  if (result != null && result is Map<String, String>) {
    setState(() {
      _zones.add(result);
      _selectedLocation = result['location'] ?? _selectedLocation;
      _hasData = true;
    });
  }
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddZonePage,
        backgroundColor: kPurple,
        elevation: 0, //??
        child: const Icon(
          Icons.add,
          size: 34,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Zones List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),),
              ),
              const SizedBox(height: 18),
              _buildTopBar(),
              const SizedBox(height: 22),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _hasData ? _buildZoneCard() : _buildEmptyCard(),
                      const SizedBox(height: 18),
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

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}