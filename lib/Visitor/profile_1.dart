import 'package:flutter/material.dart';
import 'package:rushd/shared/VisitorBottomBar1.dart';
import 'edit_profile_1.dart';
import 'faqs_1.dart';

class ProfileVisitorPage extends StatefulWidget {
  const ProfileVisitorPage({super.key});

  @override
  State<ProfileVisitorPage> createState() => _ProfileVisitorPageState();
}

class _ProfileVisitorPageState extends State<ProfileVisitorPage> {
  String visitorName = "Sara Mohammed";
  String visitorEmail = "saramohammed@gmail.com";

  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'العربية'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading:false,
        title: const Text(
          'My Profile',
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 20),

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
                    visitorName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    visitorEmail,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
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
                    Icons.help_outline,
                    'FAQ',
                    subtitle: 'Find answers to your questions',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FAQPage(),
                        ),
                      );
                    },
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
        ),
      ),
      bottomNavigationBar: const VisitorBottomBar1(currentIndex: 0),
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
      icon: const Icon(Icons.keyboard_arrow_down),
      items: languages.map((String lang) {
        return DropdownMenuItem(
          value: lang,
          child: Text(
            lang,
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: (val) {
        if (val == null) return;
        setState(() {
          selectedLanguage = val;
        });
      },
    );
  }
}