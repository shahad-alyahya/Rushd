import 'package:flutter/material.dart';

class ProfileVisitorPage extends StatefulWidget {
  const ProfileVisitorPage({super.key});

  @override
  State<ProfileVisitorPage> createState() => _ProfileVisitorPageState();
}

class _ProfileVisitorPageState extends State<ProfileVisitorPage> {
  // متغيرات الداتابيس
  String visitorName = "Sara Mohammed";
  String visitorEmail = "saramohammed@gmail.com";

  String selectedLanguage = 'English';
  List<String> languages = ['English', 'العربية'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Profile',
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

            Column(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xFFF3F0FA),
                  child: Icon(Icons.person, size: 80, color: Color(0xFF424242)),
                ),
                const SizedBox(height: 15),
                Text(
                  visitorName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  visitorEmail,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                // زر التعديل
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF424242,
                    ), // لون غامق نفس الصورة
                    shape: RoundedRectangleBorder(
                      // هنا كان الخطأ وصلحناه
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

            // --- قائمة الإعدادات (نفس صورة الآيفون بالضبط) ---
            _buildOptionTile(
              Icons.language,
              'Languages',
              trailing: _buildLanguageDropdown(),
            ),
            _buildOptionTile(
              Icons.help_outline,
              'FAQ',
              subtitle: 'Find answers to your questions',
            ),
            _buildOptionTile(
              Icons.email_outlined,
              'Contact Us',
              subtitle: 'Reach us at support@rushd.com',
            ),
            _buildOptionTile(
              Icons.logout,
              'Log out',
              subtitle: 'Sign out of your account safely',
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
