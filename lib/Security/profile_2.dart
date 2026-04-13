import 'package:flutter/material.dart';
// 1. استدعينا ملف البوتوم بار الجديد هنا
import 'security_bottom_bar.dart';

class SecurityProfilePage extends StatefulWidget {
  const SecurityProfilePage({super.key});

  @override
  State<SecurityProfilePage> createState() => _SecurityProfilePageState();
}

class _SecurityProfilePageState extends State<SecurityProfilePage> {
  // Security guard data
  String staffName = "Fahad Al-Qahtani";
  String staffEmail = "fahad.q@rushd.sa";

  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'العربية'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            width: 380, // iPhone shape constraint
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // --- Profile Card ---
                        const CircleAvatar(
                          radius: 55,
                          backgroundColor: Color(0xFFF3F0FA),
                          child: Icon(
                            Icons.security,
                            size: 70,
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
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),

                        ElevatedButton(
                          onPressed: () {},
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

                        // --- Shortlist Menu ---
                        _buildOptionTile(
                          Icons.language,
                          'Languages',
                          trailing: _buildLanguageDropdown(),
                          onTap: () {},
                        ),

                        _buildOptionTile(
                          Icons.email_outlined,
                          'Contact Us',
                          subtitle: 'Reach us at support@rushd.sa',
                          onTap: () {},
                        ),

                        _buildOptionTile(
                          Icons.logout,
                          'Log out',
                          subtitle: 'Sign out of your account',
                          isDestructive: true,
                          onTap: () {},
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

                // 2. هنا استدعينا الكلاس حق البوتوم بار، وحطينا صفر لأن هذي صفحة البروفايل (أول أيقونة)
                const SecurityBottomBar(currentIndex: 0),
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
          color: isDestructive ? Colors.redAccent : const Color(0xFF673AB7),
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

  Widget _buildLanguageDropdown() {
    return DropdownButton<String>(
      value: selectedLanguage,
      underline: const SizedBox(),
      icon: const Icon(Icons.keyboard_arrow_down),
      items: languages.map((String lang) {
        return DropdownMenuItem(
          value: lang,
          child: Text(lang, style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
      onChanged: (val) {
        if (val == null) return;
        setState(() => selectedLanguage = val);
      },
    );
  }
}
