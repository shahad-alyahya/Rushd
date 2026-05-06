import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Mesgsage_4.dart';
import 'add_security.dart';
import 'admin_bottom_bar.dart';
import 'package:rushd/Admin/export.dart';

// Screen that displays a real-time list of active security staff
class SecurityStaffList extends StatefulWidget {
  const SecurityStaffList({super.key});

  @override
  State<SecurityStaffList> createState() => _SecurityStaffListState();
}

class _SecurityStaffListState extends State<SecurityStaffList> {
  static const Color kRushdPurple = Color(0xFF867AB9);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? selectedLocationId;
  String selectedLocation = "Select Location";
  bool isLoadingLocations = true;
  // List to store locations fetched from Firestore
  List<Map<String, String>> locations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations(); // Fetch locations on screen startup
  }

  // Fetches the list of available locations from Firestore
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
        isLoadingLocations = false;
        // Automatically select the first location if the list is not empty
        if (loadedLocations.isNotEmpty) {
          selectedLocationId = loadedLocations.first['id'];
          selectedLocation = loadedLocations.first['name']!;
        }
      });
    } catch (e) {
      debugPrint('Error loading locations: $e');

      if (!mounted) return;
      setState(() {
        isLoadingLocations = false;
      });
    }
  }

  // Utility to check if a user role matches "security" keywords
  bool _isSecurityRole(dynamic roleValue) {
    final role = (roleValue ?? '').toString().trim().toLowerCase();
    return role == 'security' ||
        role == 'security staff' ||
        role == 'security_staff' ||
        role == 'securitystaff';
  }

  // Real-time stream to listen for security staff assigned to the selected location
  Stream<List<Map<String, dynamic>>> _staffStream() {
    if (selectedLocationId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .where('assignedLocationId', isEqualTo: selectedLocationId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                final data = doc.data();

                return {
                  'id': doc.id,
                  'name': (data['fullName'] ?? '').toString(),
                  'email': (data['email'] ?? '').toString(),
                  'role': (data['role'] ?? '').toString(),
                  'status': (data['status'] ?? '').toString(),
                  'assignedLocationId': (data['assignedLocationId'] ?? '')
                      .toString(),
                  'createdAt': data['createdAt'],
                  'isVerified': data['isVerified'],
                };
              }) // Filter to only show active security staff in the UI
              .where(
                (user) =>
                    _isSecurityRole(user['role']) && user['status'] == 'active',
              )
              .toList();
        });
  }

  // Navigates to the Add Security screen
  Future<void> _navigateToAddSecurity() async {
    if (selectedLocationId == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSecurity(
          selectedLocationId: selectedLocationId!,
          selectedLocationName: selectedLocation,
        ),
      ),
    );
  }

  // Displays a confirmation dialog before "deleting" a user
  void _triggerDeleteFlow(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Are you sure you want to delete this User?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "NO",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // Perform "Soft Delete" by changing status to inactive
                          await _firestore
                              .collection('users')
                              .doc(user['id'].toString())
                              .update({'status': 'inactive'});
                          if (!mounted) return;
                          Navigator.pop(context); // Close dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Message4(),
                            ),
                          );
                        } catch (e) {
                          Navigator.pop(context);
                          debugPrint('Error deleting user: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF353841),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "YES",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to format dynamic Firestore values (e.g., Timestamps) into strings
  String _formatValue(dynamic value) {
    if (value == null) return '';
    if (value is Timestamp) {
      final dt = value.toDate();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return value.toString();
  }

  // Prepares user data for PDF/Export services
  Map<String, dynamic> _normalizeUserForExport(Map<String, dynamic> user) {
    return {
      'documentId': _formatValue(user['id']),
      'fullName': _formatValue(user['name']),
      'email': _formatValue(user['email']),
      'role': _formatValue(user['role']),
      'status': _formatValue(user['status']),
      'assignedLocationId': _formatValue(user['assignedLocationId']),
      'createdAt': _formatValue(user['createdAt']),
      'isVerified': _formatValue(user['isVerified']),
    };
  }

  // Triggers report sharing for the current security list
  Future<void> _shareSecurity(List<Map<String, dynamic>> users) async {
    await ExportService.shareSecurityReport(
      location: selectedLocation,
      userDocs: users.map(_normalizeUserForExport).toList(),
    );
  }

  // Triggers PDF printing for the current security list
  Future<void> _printSecurity(List<Map<String, dynamic>> users) async {
    await ExportService.exportSecurityReport(
      location: selectedLocation,
      userDocs: users.map(_normalizeUserForExport).toList(),
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
                      "Security Staff List",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildHeader(), // Location picker and export buttons                    const SizedBox(height: 15),
                    Expanded(
                      child: selectedLocationId == null
                          ? _buildEmptyState()
                          : StreamBuilder<List<Map<String, dynamic>>>(
                              stream: _staffStream(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting &&
                                    !snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final staff = snapshot.data ?? [];

                                if (staff.isEmpty) {
                                  return _buildEmptyState();
                                }

                                return _buildStaffList(staff);
                              },
                            ),
                    ),
                    const AdminBottomBar(currentIndex: 0),
                    const SizedBox(height: 10),
                  ],
                ),
                // Floating Action Button to add new staff
                Positioned(
                  bottom: 100,
                  right: 20,
                  child: SizedBox(
                    width: 62,
                    height: 62,
                    child: FloatingActionButton(
                      onPressed: selectedLocationId == null
                          ? null
                          : _navigateToAddSecurity,
                      backgroundColor: const Color(0xFFA79ECC),
                      elevation: 5,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.add,
                        size: 32,
                        color: Colors.black,
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
// Header widget containing the Dropdown for location selection and action icons
  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: StreamBuilder<List<Map<String, dynamic>>>(
      stream: _staffStream(),
      builder: (context, snapshot) {
        final staff = snapshot.data ?? [];

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F5FB).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: isLoadingLocations
                    ? const Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedLocationId,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                          hint: const Text('Select Location'),
                          items: locations
                              .map(
                                (loc) => DropdownMenuItem<String>(
                                  value: loc['id'],
                                  child: Text(loc['name']!),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val == null) return;

                            final location = locations.firstWhere(
                              (loc) => loc['id'] == val,
                            );

                            setState(() {
                              selectedLocationId = location['id'];
                              selectedLocation = location['name']!;
                            });
                          },
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Export and Print action icons
            Row(
              children: [
                GestureDetector(
                  onTap: selectedLocationId == null
                      ? null
                      : () async {
                          await _shareSecurity(staff);
                        },
                  child: Icon(
                    Icons.ios_share,
                    size: 22,
                    color: selectedLocationId == null
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: selectedLocationId == null
                      ? null
                      : () async {
                          await _printSecurity(staff);
                        },
                  child: Icon(
                    Icons.print,
                    size: 22,
                    color: selectedLocationId == null
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
// Widget to build the scrollable list of staff members
  Widget _buildStaffList(List<Map<String, dynamic>> staff) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(10),
        itemCount: staff.length,
        separatorBuilder: (_, __) => const SizedBox(height: 18),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF353841).withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Image.asset("assets/images/user.png", width: 45, height: 45),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (staff[index]["name"] ?? '').toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      (staff[index]["email"] ?? '').toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _triggerDeleteFlow(staff[index]),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFA61A22),
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      );
// Placeholder when no data is found
  Widget _buildEmptyState() => const Center(
    child: Text('No data available', style: TextStyle(color: Colors.grey)),
  );
}
