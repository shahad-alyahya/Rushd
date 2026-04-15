import 'package:flutter/material.dart';
import 'edit_profile_2.dart';
import 'security_bottom_bar.dart';
import 'package:rushd/Visitor/loginPage.dart';

class SecurityProfilePage extends StatefulWidget {
  const SecurityProfilePage({super.key});

  @override
  State<SecurityProfilePage> createState() => _SecurityProfilePageState();
}

class _SecurityProfilePageState extends State<SecurityProfilePage> {
  final String staffName = "Layan Abdullah";
  final String staffEmail = "layan.a@rushd.sa";

  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'العربية'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile', // نفس الفيزتور
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // 👇 نفس الفيزتور
                        const CircleAvatar(
                          radius: 55,
                          backgroundColor: Color(0xFFF3F0FA),
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Color(0xFF424242),
                          ),
                        ),

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
                            color: Color(0xFF7C7E86),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // 👇 زر نفس الفيزتور
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EditProfilePageSecurity(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF424242),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        const SizedBox(height: 30),

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

                        _buildOptionTile(
                          Icons.logout,
                          'Log out',
                          subtitle: 'Sign out of your account',
                          isDestructive: true,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Logged out successfully! 👋'),
                                backgroundColor: Color(0xFF867AB9),
                              ),
                            );

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
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // بدون const ❗
                SecurityBottomBar(currentIndex: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    IconData icon,
    String title, {
    String? subtitle,
    Widget? trailing,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF3F0FA),
        child: Icon(
          icon,
          color: isDestructive
              ? Colors.redAccent
              : const Color(0xFF673AB7), // نفس الفيزتور
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12),
            )
          : null,
      trailing: trailing ??
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
    );
  }

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