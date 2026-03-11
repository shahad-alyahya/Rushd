import 'package:flutter/material.dart';
import'package:rushd/Admin/AddZonePage.dart';
import'package:rushd/Admin/message_3.dart';


class ZonesListPage extends StatefulWidget {
  const ZonesListPage({super.key});

  @override
  State<ZonesListPage> createState() => _ZonesListPageState();
}

class _ZonesListPageState extends State<ZonesListPage> {
  static const Color kPurple = Color(0xFFB8A9FF);
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

  final List<Map<String, String>> _zones = [
    {
      'name': 'Türkiye Zone',
      'location': 'Boulevard World',
    },
  ];

  List<Map<String, String>> get _filteredZones {
    return _zones
        .where((zone) => zone['location'] == _selectedLocation)
        .toList();
  }

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

  Future<void> _openAddZonePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddZonePage(
          selectedLocation: _selectedLocation,
          existingZoneNames: _zones
              .map((zone) => zone['name'] ?? '')
              .where((name) => name.isNotEmpty)
              .toList(),
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        _zones.add({
          'name': result['name'] ?? '',
          'location': result['location'] ?? _selectedLocation,
        });
      });
    }
  }

  Future<void> _showDeleteDialog(Map<String, String> zone) async {
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
                         onPressed: () async {
  setState(() {
    _zones.removeWhere(
      (item) =>
          item['name'] == zone['name'] &&
          item['location'] == zone['location'],
    );
  });

  Navigator.pop(context);

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const Message3Page(),
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

  Future<void> _showNoDataDialog(String location) async {
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
                const Text(
                  'No Data',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'There is no data available for $location.',
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

  Future<void> _onLocationChanged(String? value) async {
    if (value == null) return;

    setState(() {
      _selectedLocation = value;
    });

    final hasData = _zones.any((zone) => zone['location'] == value);

    if (!hasData) {
      await _showNoDataDialog(value);
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
              _filteredZones.isNotEmpty
                  ? 'The export action will be connected later.'
                  : 'There is no data to export for this location.',
            );
          },
        ),
        const SizedBox(width: 8),
        _ActionIconButton(
          icon: Icons.print_outlined,
          onTap: () {
            _showActionDialog(
              'Print',
              _filteredZones.isNotEmpty
                  ? 'The print action will be connected later.'
                  : 'There is no data to print for this location.',
            );
          },
        ),
      ],
    );
  }

  Widget _buildZoneCard(Map<String, String> zone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
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
          Expanded(
            child: Text(
              zone['name'] ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          InkWell(
            onTap: () => _showDeleteDialog(zone),
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

  Widget _buildBottomBar() {
    return Container(
      height: 74,
      margin: const EdgeInsets.symmetric(horizontal: 34, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.person_outline_rounded, size: 28),
          Icon(Icons.home_rounded, size: 28),
          Icon(Icons.location_on_outlined, size: 28),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddZonePage,
        backgroundColor: kPurple,
        elevation: 0,
        child: const Icon(
          Icons.add,
          size: 34,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomBar(),
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
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _buildTopBar(),
              const SizedBox(height: 22),
              Expanded(
                child: _filteredZones.isEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildEmptyCard(),
                            const SizedBox(height: 18),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filteredZones.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final zone = _filteredZones[index];
                          return _buildZoneCard(zone);
                        },
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