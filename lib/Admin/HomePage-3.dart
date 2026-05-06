import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rushd/Admin/export.dart';
import 'admin_bottom_bar.dart';
import 'package:rushd/Visitor/loginPage.dart';
// Main Dashboard for the Admin to monitor crowd statistics and export reports
class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // State variables for filtering and data selection
  String activeFilter = 'Daily';// Can be Daily, Monthly, or Yearly
  String? selectedLocationId;
  String selectedLocationName = 'Select Location';
  DateTime selectedDate = DateTime.now();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, String>> locations = [];
  Future<Map<String, dynamic>>? _panelStatsFuture;
// Helper to trigger a data refresh from Firestore
  void _refreshPanelStats() {
    _panelStatsFuture = _fetchPanelStats();
  }

  @override
  void initState() {
    super.initState();
    // Load available locations immediately on page launch
    _loadLocations();
  }
// Fetches the list of locations managed by the system
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
        locations = loadedLocations;
        // Default to the first location if available
        if (loadedLocations.isNotEmpty) {
          selectedLocationId = loadedLocations.first['id'];
          selectedLocationName = loadedLocations.first['name']!;
          _refreshPanelStats();
        }
      });
    } catch (e) {
      debugPrint('Error loading locations: $e');
    }
  }
// Opens date picker to change the report focus
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF867AB9)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _refreshPanelStats();
      });
    }
  }
// Shows a bottom sheet to pick between different locations
  void _showLocationPicker() {
    if (locations.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ...locations.map(
                (loc) => ListTile(
                  title: Text(
                    loc['name']!,
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    setState(() {
                      selectedLocationId = loc['id'];
                      selectedLocationName = loc['name']!;
                      _refreshPanelStats();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
// calculate the start and end of periods for filtering queries
  DateTime get _startOfDay =>
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

  DateTime get _endOfDay => _startOfDay.add(const Duration(days: 1));

  DateTime get _startOfMonth =>
      DateTime(selectedDate.year, selectedDate.month, 1);

  DateTime get _endOfMonth => selectedDate.month == 12
      ? DateTime(selectedDate.year + 1, 1, 1)
      : DateTime(selectedDate.year, selectedDate.month + 1, 1);

  DateTime get _startOfYear => DateTime(selectedDate.year, 1, 1);

  DateTime get _endOfYear => DateTime(selectedDate.year + 1, 1, 1);
// Returns the current date range based on the active filter
  ({DateTime start, DateTime end}) _getSelectedRange() {
    if (activeFilter == 'Daily') {
      return (start: _startOfDay, end: _endOfDay);
    } else if (activeFilter == 'Monthly') {
      return (start: _startOfMonth, end: _endOfMonth);
    } else {
      return (start: _startOfYear, end: _endOfYear);
    }
  }
// Formatting helpers for dates and labels
  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _formatDateTime(DateTime dateTime) {
    return '${_twoDigits(dateTime.day)}/${_twoDigits(dateTime.month)}/${dateTime.year} '
        '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}';
  }

  String _formattedSelectedDate() {
    if (activeFilter == 'Daily') {
      return '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
    } else if (activeFilter == 'Monthly') {
      return '${selectedDate.month}/${selectedDate.year}';
    } else {
      return '${selectedDate.year}';
    }
  }

  String _reportPeriodLabel() {
    if (activeFilter == 'Daily') {
      return 'Daily';
    } else if (activeFilter == 'Monthly') {
      return 'Monthly';
    } else {
      return 'Yearly';
    }
  }
// Checks if a user has a security-related role
  bool _isSecurityRole(dynamic roleValue) {
    final role = (roleValue ?? '').toString().trim().toLowerCase();
    return role == 'security' ||
        role == 'security staff' ||
        role == 'security_staff' ||
        role == 'securitystaff';
  }
// Flexible date parser for multiple data types (Timestamp, int, String)
  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }

    if (value is Map<String, dynamic>) {
      if (value['_seconds'] != null) {
        final seconds = (value['_seconds'] as num).toInt();
        final nanos = ((value['_nanoseconds'] ?? 0) as num).toInt();
        return DateTime.fromMillisecondsSinceEpoch(
          (seconds * 1000) + (nanos ~/ 1000000),
        );
      }
    }

    return null;
  }
// Tries to find a valid date field within a reading document
  DateTime? _extractReadingDate(Map<String, dynamic> data) {
    return _parseDate(data['processedAt']) ??
        _parseDate(data['createdAt']) ??
        _parseDate(data['updatedAt']) ??
        _parseDate(data['lastUpdatedAt']) ??
        _parseDate(data['timestamp']);
  }
// Validates if a specific date falls within the selected period
  bool _isInSelectedRange(DateTime? date) {
    if (date == null) return false;
    final range = _getSelectedRange();
    return !date.isBefore(range.start) && date.isBefore(range.end);
  }
// Normalizes Firestore data into standard JSON-friendly formats for reporting
  Map<String, dynamic> _normalizeMap(Map<String, dynamic> source) {
    final result = <String, dynamic>{};

    for (final entry in source.entries) {
      final value = entry.value;
      if (value is Timestamp) {
        result[entry.key] = _formatDateTime(value.toDate());
      } else if (value is DateTime) {
        result[entry.key] = _formatDateTime(value);
      } else if (value is GeoPoint) {
        result[entry.key] = '${value.latitude}, ${value.longitude}';
      } else if (value is DocumentReference) {
        result[entry.key] = value.path;
      } else if (value is List) {
        result[entry.key] = value.map((e) {
          if (e is Timestamp) return _formatDateTime(e.toDate());
          if (e is DateTime) return _formatDateTime(e);
          return e;
        }).toList();
      } else if (value is Map) {
        result[entry.key] = value.map(
          (key, val) => MapEntry(key.toString(), val.toString()),
        );
      } else {
        result[entry.key] = value;
      }
    }

    return result;
  }
  // High-level aggregator that fetches zones, users, and filtered readings
Future<Map<String, dynamic>> _fetchAllAdminData() async {
  if (selectedLocationId == null) {
    return {
      'visitors': 0,
      'security': 0,
      'zones': 0,
      'zoneDocs': <Map<String, dynamic>>[],
      'userDocs': <Map<String, dynamic>>[],
      'readingDocs': <Map<String, dynamic>>[],
    };
  }

  try {
    final zonesSnap = await _firestore
        .collection('zones')
        .where('locationId', isEqualTo: selectedLocationId)
        .get();

    final usersSnap = await _firestore
        .collection('users')
        .where('assignedLocationId', isEqualTo: selectedLocationId)
        .get();

    final readingsSnap = await _firestore.collection('sensor_readings').get();

    final zoneDocs = zonesSnap.docs.map((doc) {
      final data = _normalizeMap(doc.data());
      data['documentId'] = doc.id;
      return data;
    }).toList();

    final userDocs = usersSnap.docs.map((doc) {
      final data = _normalizeMap(doc.data());
      data['documentId'] = doc.id;
      return data;
    }).toList();

    final filteredReadings = <Map<String, dynamic>>[];
    int totalVisitors = 0;

    for (final doc in readingsSnap.docs) {
      final raw = doc.data();
      final readingDate = _extractReadingDate(raw);
      if (!_isInSelectedRange(readingDate)) continue;

      final locationId = (raw['locationId'] ?? '').toString();
      if (locationId != selectedLocationId) continue;

      final eventType = (raw['eventType'] ?? '').toString().trim().toLowerCase();

      if (eventType == 'entered') {
        totalVisitors++;
      }

      final data = _normalizeMap(raw);
      data['documentId'] = doc.id;
      data['readingDate'] =
          readingDate != null ? _formatDateTime(readingDate) : '';
      filteredReadings.add(data);
    }
// Sort readings so newest data appears first
    filteredReadings.sort((a, b) {
      final aDate = a['readingDate'].toString();
      final bDate = b['readingDate'].toString();
      return bDate.compareTo(aDate);
    });

    final securityCount =
        userDocs.where((u) => _isSecurityRole(u['role'])).length;

    return {
      'visitors': totalVisitors,
      'security': securityCount,
      'zones': zoneDocs.length,
      'zoneDocs': zoneDocs,
      'userDocs': userDocs,
      'readingDocs': filteredReadings,
    };
  } catch (e) {
    debugPrint('Error fetching admin data: $e');
    return {
      'visitors': 0,
      'security': 0,
      'zones': 0,
      'zoneDocs': <Map<String, dynamic>>[],
      'userDocs': <Map<String, dynamic>>[],
      'readingDocs': <Map<String, dynamic>>[],
    };
  }
}// Minimal version of data fetching for the UI metric cards
  Future<Map<String, dynamic>> _fetchPanelStats() async {
    final data = await _fetchAllAdminData();
    return {
      'visitors': data['visitors'] as int,
      'security': data['security'] as int,
      'zones': data['zones'] as int,
    };
  }
// Sends the compiled data to the ExportService for PDF sharing
  Future<void> _shareReport() async {
    final details = await _fetchAllAdminData();

    await ExportService.shareFullReport(
      location: selectedLocationName,
      selectedDate: selectedDate,
      periodLabel: _reportPeriodLabel(),
      visitors: details['visitors'] as int,
      security: details['security'] as int,
      zones: details['zones'] as int,
      zoneDocs: (details['zoneDocs'] as List).cast<Map<String, dynamic>>(),
      userDocs: (details['userDocs'] as List).cast<Map<String, dynamic>>(),
      readingDocs: (details['readingDocs'] as List).cast<Map<String, dynamic>>(),
    );
  }
// Sends the compiled data to the ExportService for printing
  Future<void> _printReport() async {
    final details = await _fetchAllAdminData();

    await ExportService.exportFullReport(
      location: selectedLocationName,
      selectedDate: selectedDate,
      periodLabel: _reportPeriodLabel(),
      visitors: details['visitors'] as int,
      security: details['security'] as int,
      zones: details['zones'] as int,
      zoneDocs: (details['zoneDocs'] as List).cast<Map<String, dynamic>>(),
      userDocs: (details['userDocs'] as List).cast<Map<String, dynamic>>(),
      readingDocs: (details['readingDocs'] as List).cast<Map<String, dynamic>>(),
    );
  }
// Logic to sign out and clear the navigation stack
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8FA),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: _panelStatsFuture,
                      builder: (context, snapshot) {
                        final stats = snapshot.data ??
                            {
                              'visitors': 0,
                              'security': 0,
                              'zones': 0,
                            };

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 25),
                            _buildHeader(),
                            const SizedBox(height: 30),
                            _buildMetricOverview(
                              visitors: stats['visitors'] as int,
                              security: stats['security'] as int,
                              zones: stats['zones'] as int,
                            ),
                            const SizedBox(height: 30),
                            _buildPeriodToggle(),
                            const SizedBox(height: 35),
                            const Text(
                              'Select Location',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildSelectionBox(
                              selectedLocationName,
                              Icons.keyboard_arrow_down,
                              _showLocationPicker,
                            ),
                            const SizedBox(height: 25),
                            const Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildSelectionBox(
                              _formattedSelectedDate(),
                              Icons.calendar_month,
                              _pickDate,
                            ),
                            const SizedBox(height: 40),
                            _buildQuickActions(),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const AdminBottomBar(currentIndex: 1),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
// Dashboard Header widget
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi Admin!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Welcome to your panel.',
              style: TextStyle(fontSize: 15, color: Color(0xFF969696)),
            ),
          ],
        ),
        GestureDetector(
          onTap: _logout,
          child: const Icon(Icons.logout, color: Color(0xFFA61A22), size: 26),
        ),
      ],
    );
  }
// UI Container for the key metrics cards
  Widget _buildMetricOverview({
    required int visitors,
    required int security,
    required int zones,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDAD5F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildSimpleCard(
            'Visitors',
            visitors.toString(),
            height: 90,
            fullWidth: true,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildSimpleCard(
                  'Security',
                  security.toString(),
                  height: 110,
                  icon: Icons.security,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildSimpleCard(
                  'Zones',
                  zones.toString(),
                  height: 110,
                  icon: Icons.location_on_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
// Segmented control to switch between time filters
  Widget _buildPeriodToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Row(
        children: ['Daily', 'Monthly', 'Yearly'].map((label) {
          final isSelected = activeFilter == label;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  activeFilter = label;
                  _refreshPanelStats();
                });
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF867AB9)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
// Reusable component for selection inputs
  Widget _buildSelectionBox(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F5FB).withOpacity(0.6),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Icon(icon, size: 20, color: Colors.black54),
          ],
        ),
      ),
    );
  }
// Reusable card for displaying values and titles
  Widget _buildSimpleCard(
    String title,
    String value, {
    required double height,
    bool fullWidth = false,
    IconData? icon,
  }) {
    return Container(
      height: height,
      width: fullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, color: const Color(0xFF867AB9), size: 24),
          if (icon != null) const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF010E16),
            ),
          ),
        ],
      ),
    );
  }
// Export actions row (Share and Print)
  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildCircleIcon(
          Icons.ios_share_outlined,
          () async {
            await _shareReport();
          },
        ),
        const SizedBox(width: 15),
        _buildCircleIcon(
          Icons.print,
          () async {
            await _printReport();
          },
        ),
      ],
    );
  }
// Helper for floating-style circular action buttons
  Widget _buildCircleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Icon(icon, size: 22, color: Colors.black87),
      ),
    );
  }
}