import 'package:flutter/material.dart';
import 'package:rushd/Admin/export.dart';
// --- Navigation & Core Modules ---
import 'admin_bottom_bar.dart';
import 'package:rushd/Visitor/loginPage.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String activeFilter = 'Daily';
  String selectedLocation = 'Boulevard World';
  DateTime selectedDate = DateTime(2025, 10, 15);

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF867AB9)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  void _showLocationPicker() {
    final List<String> locations = [
      'Boulevard World',
      'Bujairi Terrace',
      'Boulevard City',
      'Via Riyadh',
    ];

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
                  title: Text(loc, textAlign: TextAlign.center),
                  onTap: () {
                    setState(() => selectedLocation = loc);
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
                        _buildHeader(context),
                        const SizedBox(height: 30),
                        _buildMetricOverview(),
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
                          selectedLocation,
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
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          Icons.calendar_month,
                          _pickDate,
                        ),
                        const SizedBox(height: 40),
                        _buildQuickActions(),
                        const SizedBox(height: 20),
                      ],
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          ),
          child: const Icon(Icons.logout, color: Color(0xFFA61A22), size: 26),
        ),
      ],
    );
  }

  Widget _buildMetricOverview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDAD5F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildSimpleCard('Visitors', '7,783', height: 90, fullWidth: true),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildSimpleCard(
                  'Security',
                  '4,120',
                  height: 110,
                  icon: Icons.security,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildSimpleCard(
                  'Zones',
                  '87',
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
        children: ['Daily', 'Monthly', 'Year'].map((label) {
          final bool isSelected = activeFilter == label;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => activeFilter = label),
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

Widget _buildQuickActions() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      _buildCircleIcon(
        Icons.ios_share_outlined,
        () async {
          await ExportService.shareAdminReport(
            location: selectedLocation,
            selectedDate: selectedDate,
            filter: activeFilter,
            visitors: 7783,
            security: 4120,
            zones: 87,
          );
        },
      ),
      const SizedBox(width: 15),
      _buildCircleIcon(
        Icons.print,
        () async {
          await ExportService.exportAdminReport(
            location: selectedLocation,
            selectedDate: selectedDate,
            filter: activeFilter,
            visitors: 7783,
            security: 4120,
            zones: 87,
          );
        },
      ),
    ],
  );
}
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