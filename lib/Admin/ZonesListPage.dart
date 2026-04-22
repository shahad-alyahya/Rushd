
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddZonePage.dart';
import 'message_3.dart';
import 'admin_bottom_bar.dart';
import 'package:rushd/Admin/export.dart';

class ZonesListPage extends StatefulWidget {
  const ZonesListPage({super.key});

  @override
  State<ZonesListPage> createState() => _ZonesListPageState();
}

class _ZonesListPageState extends State<ZonesListPage> {
  static const Color kRushdPurple = Color(0xFF867AB9);
  static const Color kDestructive = Color(0xFF9B4A4A);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedLocationId;
  String _selectedLocation = 'Select Location';
  bool _isLoadingLocations = true;

  List<Map<String, String>> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    try {
      final snapshot = await _firestore.collection('locations').get();

      final loadedLocations = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': (data['locationName'] ?? doc.id).toString(),
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        _locations = loadedLocations;
        _isLoadingLocations = false;

        if (loadedLocations.isNotEmpty) {
          _selectedLocationId = loadedLocations.first['id'];
          _selectedLocation = loadedLocations.first['name']!;
        }
      });
    } catch (e) {
      debugPrint('Error loading locations: $e');
      if (!mounted) return;
      setState(() {
        _isLoadingLocations = false;
      });
    }
  }

  Stream<List<Map<String, dynamic>>> _zonesStream() {
    if (_selectedLocationId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('zones')
        .where('locationId', isEqualTo: _selectedLocationId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return {
          'id': doc.id,
          'name': (data['zoneName'] ?? '').toString(),
          'locationId': (data['locationId'] ?? '').toString(),
          'areaSize': data['areaSize'],
          'capacity': data['capacity'],
          'congestionLevel': (data['congestionLevel'] ?? '').toString(),
          'currentCount': data['currentCount'],
          'density': data['density'],
          'highThreshold': data['highThreshold'],
          'mediumThreshold': data['mediumThreshold'],
          'lowThreshold': data['lowThreshold'],
          'lastUpdated': data['lastUpdated'],
        };
      }).toList();
    });
  }

  Future<void> _navigateToAddZone(List<Map<String, dynamic>> currentZones) async {
    final existingZoneNames = currentZones
        .map((z) => (z['name'] ?? '').toString())
        .where((name) => name.isNotEmpty)
        .toList();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddZonePage(
          selectedLocation: _selectedLocation,
          existingZoneNames: existingZoneNames,
        ),
      ),
    );
  }

  Future<void> _confirmDeletion(Map<String, dynamic> zone) async {
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
              onPressed: () async {
                try {
                  await _firestore.collection('zones').doc(zone['id']).delete();

                  if (!mounted) return;
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Message3Page(),
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  debugPrint('Error deleting zone: $e');
                }
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

  Map<String, dynamic> _normalizeZoneForExport(Map<String, dynamic> zone) {
    String formatValue(dynamic value) {
      if (value == null) return '';
      if (value is Timestamp) {
        final dt = value.toDate();
        return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
      }
      return value.toString();
    }

    return {
      'documentId': formatValue(zone['id']),
      'zoneName': formatValue(zone['name']),
      'locationId': formatValue(zone['locationId']),
      'areaSize': formatValue(zone['areaSize']),
      'capacity': formatValue(zone['capacity']),
      'congestionLevel': formatValue(zone['congestionLevel']),
      'currentCount': formatValue(zone['currentCount']),
      'density': formatValue(zone['density']),
      'highThreshold': formatValue(zone['highThreshold']),
      'mediumThreshold': formatValue(zone['mediumThreshold']),
      'lowThreshold': formatValue(zone['lowThreshold']),
      'lastUpdated': formatValue(zone['lastUpdated']),
    };
  }

  Future<void> _shareZones(List<Map<String, dynamic>> zones) async {
    await ExportService.shareZonesReport(
      location: _selectedLocation,
      zoneDocs: zones.map(_normalizeZoneForExport).toList(),
    );
  }

  Future<void> _printZones(List<Map<String, dynamic>> zones) async {
    await ExportService.exportZonesReport(
      location: _selectedLocation,
      zoneDocs: zones.map(_normalizeZoneForExport).toList(),
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
                      child: _selectedLocationId == null
                          ? _buildEmptyState()
                          : StreamBuilder<List<Map<String, dynamic>>>(
                              stream: _zonesStream(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting &&
                                    !snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final zones = snapshot.data ?? [];

                                if (zones.isEmpty) {
                                  return _buildEmptyState();
                                }

                                return _buildZoneListView(zones);
                              },
                            ),
                    ),
                    const AdminBottomBar(currentIndex: 2),
                    const SizedBox(height: 10),
                  ],
                ),
                Positioned(
                  bottom: 100,
                  right: 20,
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _zonesStream(),
                    builder: (context, snapshot) {
                      final zones = snapshot.data ?? [];

                      return SizedBox(
                        width: 60,
                        height: 60,
                        child: FloatingActionButton(
                          onPressed: _selectedLocationId == null
                              ? null
                              : () => _navigateToAddZone(zones),
                          backgroundColor: kRushdPurple,
                          elevation: 6,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
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
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _zonesStream(),
        builder: (context, snapshot) {
          final zones = snapshot.data ?? [];

          return Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F5FB).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _isLoadingLocations
                      ? const Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedLocationId,
                            isExpanded: true,
                            hint: const Text('Select Location'),
                            items: _locations
                                .map(
                                  (loc) => DropdownMenuItem<String>(
                                    value: loc['id'],
                                    child: Text(loc['name']!),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val == null) return;

                              final location = _locations.firstWhere(
                                (loc) => loc['id'] == val,
                              );

                              setState(() {
                                _selectedLocationId = location['id'];
                                _selectedLocation = location['name']!;
                              });
                            },
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _selectedLocationId == null
                    ? null
                    : () async {
                        await _shareZones(zones);
                      },
                child: Icon(
                  Icons.ios_share,
                  size: 22,
                  color: _selectedLocationId == null ? Colors.grey : Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _selectedLocationId == null
                    ? null
                    : () async {
                        await _printZones(zones);
                      },
                child: Icon(
                  Icons.print,
                  size: 22,
                  color: _selectedLocationId == null ? Colors.grey : Colors.black,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildZoneListView(List<Map<String, dynamic>> zones) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: zones.length,
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final zone = zones[index];
        return _ZoneTile(
          name: (zone['name'] ?? '').toString(),
          onDelete: () => _confirmDeletion(zone),
        );
      },
    );
  }

  Widget _buildEmptyState() => const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
}

class _ZoneTile extends StatelessWidget {
  final String name;
  final VoidCallback onDelete;

  const _ZoneTile({
    required this.name,
    required this.onDelete,
  });

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
            icon: const Icon(
              Icons.delete_outline,
              color: Color(0xFF9B4A4A),
            ),
          ),
        ],
      ),
    );
  }
}