import 'package:flutter/material.dart';
// التعديل هنا: اسم المجلد بعدين اسم الملف/import 'security/home_page2.dart';
import 'visitor/profile_1.dart';
import 'visitor/faqs_1.dart';
import 'visitor/edit_profile_1.dart';
import 'security/edit_profile_2.dart';
//import 'security/f.dart';
import 'security/home_page2.dart';

import 'security/profile_2.dart';

void main() {
  runApp(const RushdApp());
}

class RushdApp extends StatelessWidget {
  const RushdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),

      home: const FAQPage(),
      //home: const SecurityProfilePage(),
      //home: const EditProfilePageSecurity(),
      //home: const HomePage2(),

      //home: const ProfileVisitorPage(),
      //home: const SecurityDashboardPage(),
    );
  }
}
