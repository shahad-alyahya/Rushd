import 'package:flutter/material.dart';
// Internal navigation imports
import 'edit_profile_2.dart';
import 'security_bottom_bar.dart';
// Importing LoginPage from Visitor section for logout functionality
import 'package:rushd/Visitor/loginPage.dart';

class SecurityProfilePage extends StatefulWidget {
  const SecurityProfilePage({super.key});

  @override
  State<SecurityProfilePage> createState() => _SecurityProfilePageState();
}

class _SecurityProfilePageState extends State<SecurityProfilePage> {
  // Mock profile data - In a real app, this would be fetched from a database
  final String staffName = "Layan Abdullah";
  final String staffEmail = "layan.a@rushd.sa";
  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'العربية'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevents accidental back navigation
        title: const Text(
          'Security Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            // Maintains a professional mobile aspect ratio across all devices
            width: 380,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    // iOS-style bounce physics for premium user experience
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // User avatar section with themed border
                        _buildProfileAvatar(),

                        const SizedBox(height: 15),
                        Text(
                          staffName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          staffEmail,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Action button to trigger profile modification
                        _buildEditProfileButton(context),

                        const SizedBox(height: 30),

                        // Settings and utilities menu
                        _buildOptionTile(
                          Icons.language,
                          'Languages',
                          trailing: _buildLanguageDropdown(),
                        ),
                        _buildOptionTile(
                          Icons.email_outlined,
                          'Contact Us',
                          subtitle: 'Reach us at support@rushd.sa',
                        ),

                        // --- LOGOUT OPTION ---
                        _buildOptionTile(
                          Icons.logout,
                          'Log out',
                          subtitle: 'Sign out of your account',
                          isDestructive: true,
                          onTap: () {
                            // 1. Show feedback message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Logged out successfully! 👋'),
                                backgroundColor: Color(0xFF867AB9),
                                duration: Duration(seconds: 2),
                              ),
                            );

                            // 2. Navigate to Login Page and clear all previous routes
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                        ),

                        const SizedBox(height: 40),
                        const Text(
                          'App Version 1.0.0',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                // Persistent bottom navigation bar - Index 0 for Profile
                const SecurityBottomBar(currentIndex: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Component: The circular profile avatar
  Widget _buildProfileAvatar() {
    return const CircleAvatar(
      radius: 55,
      backgroundColor: Color(0xFFF3F0FA),
      child: Icon(Icons.security, size: 70, color: Color(0xFF867AB9)),
    );
  }

  // Component: Styled Edit Profile button
  Widget _buildEditProfileButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Pushes the Edit Profile screen onto the navigation stack
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditProfilePageSecurity(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF867AB9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
    );
  }

  // Helper: Builds a standardized list tile for menu options
  Widget _buildOptionTile(
    IconData icon,
    String title, {
    String? subtitle,
    Widget? trailing,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap, // Added onTap functionality
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF3F0FA),
        child: Icon(
          icon,
          color: isDestructive ? Colors.redAccent : const Color(0xFF867AB9),
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }

  // Helper: Language selection dropdown logic
  Widget _buildLanguageDropdown() {
    return DropdownButton<String>(
      value: selectedLanguage,
      underline: const SizedBox(),
      items: languages
          .map((l) => DropdownMenuItem(value: l, child: Text(l)))
          .toList(),
      onChanged: (val) => setState(() => selectedLanguage = val!),
    );
  }
}
