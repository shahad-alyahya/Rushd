import 'package:flutter/material.dart';
import 'AddZonePage.dart';
import 'message_3.dart';
import 'admin_bottom_bar.dart';

/// [ZonesListPage] serves as the dynamic registry for all operational zones.
/// It maintains a synchronized state with the creation module to reflect real-time updates.
class ZonesListPage extends StatefulWidget {
  const ZonesListPage({super.key});

  @override
  State<ZonesListPage> createState() => _ZonesListPageState();
}

class _ZonesListPageState extends State<ZonesListPage> {
  static const Color kRushdPurple = Color(0xFF867AB9);
  static const Color kDestructive = Color(0xFF9B4A4A);

  String _selectedLocation = 'Boulevard World';
  final List<String> _locations = const [
    'Boulevard World',
    'Boulevard City',
    'Al-Bujairi',
    'Riyadh Zoo',
  ];

  // --- Simulated Database: Initializing with your requested zones ---
  final List<Map<String, String>> _zones = [
    {'name': 'Türkiye Zone', 'location': 'Boulevard World'},
    {'name': 'Africa Zone', 'location': 'Boulevard World'},
    {'name': 'Saudi Arabia Zone', 'location': 'Boulevard World'},
    {'name': 'Korea Zone', 'location': 'Boulevard World'},
    {'name': 'Greece Zone', 'location': 'Boulevard World'},
    {'name': 'Kuwait Zone', 'location': 'Boulevard World'},
  ];

  List<Map<String, String>> get _filteredZones =>
      _zones.where((z) => z['location'] == _selectedLocation).toList();

  /// Handles the ingestion of new zone records from the AddZonePage module.
  /// Synchronizes the UI state with the updated registry payload.
  void _navigateToAddZone() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddZonePage(
          selectedLocation: _selectedLocation,
          existingZoneNames: _zones.map((z) => z['name']!).toList(),
        ),
      ),
    );

    // [DATABASE LOGIC] If data is returned, commit to the list and rebuild UI
    if (result != null && result is Map<String, String>) {
      setState(() {
        _zones.add(result);
      });
    }
  }

  Future<void> _confirmDeletion(Map<String, String> zone) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Confirm Deletion',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('Are you sure you want to delete "${zone['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'NO',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDestructive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                setState(() => _zones.remove(zone));
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Message3Page()),
                );
              },
              child: const Text(
                'YES',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380,
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      'Zones List',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFilterHeader(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _filteredZones.isEmpty
                          ? _buildEmptyState()
                          : _buildZoneListView(),
                    ),
                    const AdminBottomBar(currentIndex: 2),
                    const SizedBox(height: 10),
                  ],
                ),
                Positioned(
                  bottom: 100,
                  right: 20,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: FloatingActionButton(
                      onPressed: _navigateToAddZone,
                      backgroundColor: kRushdPurple,
                      elevation: 6,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLocation,
                  items: _locations
                      .map(
                        (loc) => DropdownMenuItem(value: loc, child: Text(loc)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedLocation = val!),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.ios_share, size: 22),
          const SizedBox(width: 8),
          const Icon(Icons.print, size: 22),
        ],
      ),
    );
  }

  Widget _buildZoneListView() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: _filteredZones.length,
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final zone = _filteredZones[index];
        return _ZoneTile(
          name: zone['name']!,
          onDelete: () => _confirmDeletion(zone),
        );
      },
    );
  }

  Widget _buildEmptyState() => const Center(
    child: Text('No data available', style: TextStyle(color: Colors.grey)),
  );
}

class _ZoneTile extends StatelessWidget {
  final String name;
  final VoidCallback onDelete;
  const _ZoneTile({required this.name, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Color(0xFF9B4A4A)),
          ),
        ],
      ),
    );
  }
}
