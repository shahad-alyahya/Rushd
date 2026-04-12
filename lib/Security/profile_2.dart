import 'package:flutter/material.dart';

class SecurityProfilePage extends StatefulWidget {
  const SecurityProfilePage({super.key});

  @override
  State<SecurityProfilePage> createState() => _SecurityProfilePageState();
}

class _SecurityProfilePageState extends State<SecurityProfilePage> {
  // بيانات رجل الأمن
  String staffName = "Fahad Al-Qahtani";
  String staffEmail = "fahad.q@rushd.sa";

  String selectedLanguage = 'English';
  List<String> languages = ['English', 'العربية'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Security Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- الكرت الشخصي ---
            Column(
              children: [
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
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () {
                    // الربط بصفحة EditSecurityProfilePage
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
              ],
            ),

            const SizedBox(height: 30),

            // --- القائمة المختصرة (نفس طلبك يا لولو) ---

            // 1. Languages
            _buildOptionTile(
              Icons.language,
              'Languages',
              trailing: _buildLanguageDropdown(),
            ),

            // 2. Contact Us (بدال الأمان والمعلومات)
            _buildOptionTile(
              Icons.email_outlined,
              'Contact Us',
              subtitle: 'Reach us at support@rushd.sa',
            ),

            // 3. Log out
            _buildOptionTile(
              Icons.logout,
              'Log out',
              subtitle: 'Sign out of your account',
              isDestructive: true,
            ),

            const SizedBox(height: 40),
            const Text(
              'App Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ميثود بناء الخيارات
  Widget _buildOptionTile(
    IconData icon,
    String title, {
    String? subtitle,
    Widget? trailing,
    bool isDestructive = false,
  }) {
    return ListTile(
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

  // دروب داون اللغة
  Widget _buildLanguageDropdown() {
    return DropdownButton<String>(
      value: selectedLanguage,
      underline: const SizedBox(),
      icon: const Icon(Icons.keyboard_arrow_down),
      items: languages
          .map(
            (String lang) => DropdownMenuItem(
              value: lang,
              child: Text(lang, style: const TextStyle(fontSize: 14)),
            ),
          )
          .toList(),
      onChanged: (val) => setState(() => selectedLanguage = val!),
    );
  }
}
