import 'package:flutter/material.dart';
import 'Mesgsage_4.dart';
import 'add_security.dart';
import 'admin_bottom_bar.dart';
import 'package:rushd/Admin/export.dart';


/// [SecurityStaffList] acts as the centralized view for all active personnel.
/// It maintains high-fidelity synchronization with the AddSecurity module for record persistence.
class SecurityStaffList extends StatefulWidget {
  const SecurityStaffList({super.key});
  @override
  State<SecurityStaffList> createState() => _SecurityStaffListState();
}

class _SecurityStaffListState extends State<SecurityStaffList> {
  static const Color kRushdPurple = Color(0xFF867AB9);
  String selectedLocation = "Boulevard World";

  // --- Updated: Dynamic location list matching the UI requirements ---
  final List<String> _locations = [
    "Boulevard World",
    "Boulevard City",
    "Al-Bujairi",
    "Riyadh Zoo",
  ];

  // --- Simulated Registry Database ---
  final List<Map<String, String>> staff = [
    {"name": "Fahad Mohammed", "email": "fahadmohammed@gmail.com"},
    {"name": "Abdurahman Almutari", "email": "abdurahmanalmutari@gmail.com"},
  ];

  /// Navigates to the onboarding form and synchronizes returned data with the local registry.
  void _navigateToAddSecurity() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddSecurity()),
    );

    // [DATABASE SYNC] Append new personnel record to the state list if returned
    if (result != null && result is Map<String, String>) {
      setState(() {
        staff.add(result);
      });
    }
  }

  void _triggerDeleteFlow(int index) {
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
                      onPressed: () {
                        setState(() => staff.removeAt(index));
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Message4(),
                          ),
                        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width:
                380, // Ensuring consistent iPhone aesthetic for the Admin Panel
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
                    _buildHeader(),
                    const SizedBox(height: 15),
                    Expanded(child: _buildStaffList()),
                    const AdminBottomBar(currentIndex: 0),
                    const SizedBox(height: 10),
                  ],
                ),
                Positioned(
                  bottom: 100,
                  right: 20,
                  child: SizedBox(
                    width: 62,
                    height: 62,
                    child: FloatingActionButton(
                      onPressed: _navigateToAddSecurity,
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

  /// Builds the contextual filtering header with dynamic location selection.
  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedLocation,
            icon: const Icon(Icons.keyboard_arrow_down, size: 20),
            // Mapping the full location list to dropdown entries
            items: _locations
                .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                .toList(),
            onChanged: (val) => setState(() => selectedLocation = val!),
          ),
        ),
       Row(
  children: [
    GestureDetector(
  onTap: () async {
    await ExportService.shareSecurityReport(
      location: selectedLocation,
      securityNames: staff.map((s) => s['name']!).toList(),
    );
  },
  child: const Icon(Icons.ios_share, size: 22),
),

const SizedBox(width: 15),

GestureDetector(
  onTap: () async {
    await ExportService.exportSecurityReport(
      location: selectedLocation,
      securityNames: staff.map((s) => s['name']!).toList(),
    );
  },
  child: const Icon(Icons.print, size: 22),
),
  ],
),
        
      ],
    ),
  );

  Widget _buildStaffList() => ListView.separated(
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
                  staff[index]["name"]!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  staff[index]["email"]!,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _triggerDeleteFlow(index),
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
}
