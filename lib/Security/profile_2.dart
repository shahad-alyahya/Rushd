import 'package:flutter/material.dart';
import 'edit_profile_2.dart';
import 'security_bottom_bar.dart';
import 'package:rushd/Visitor/loginPage.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecurityProfilePage extends StatefulWidget {
  const SecurityProfilePage({super.key});

  @override
  State<SecurityProfilePage> createState() => _SecurityProfilePageState();
}

class _SecurityProfilePageState extends State<SecurityProfilePage> {
  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'العربية'];

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: user == null
          ? const Center(child: Text("No user logged in"))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;

                if (data == null) {
                  return const Center(child: Text("User data not found"));
                }

                final fullName = data['fullName'] ?? "No Name";
                final email = data['email'] ?? "No Email";

                return SafeArea(
                  child: Center(
                    child: SizedBox(
                      width: 380,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
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
                                    fullName,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    email,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF7C7E86),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

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
                                      backgroundColor:
                                          const Color(0xFF424242),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
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
                                    onTap: () async {
                                      await FirebaseAuth.instance.signOut();

                                      if (!mounted) return;

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
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

                          SecurityBottomBar(currentIndex: 0),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
              : const Color(0xFF673AB7),
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
      onChanged: (val) {
        if (val == null) return;
        setState(() => selectedLanguage = val);
      },
    );
  }
}