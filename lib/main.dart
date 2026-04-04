import 'package:flutter/material.dart';

// استدعاء ملفات الزائر (Visitor)
//import 'Visitor/profile_1.dart';
//import 'Visitor/edit_profile_1.dart';
//import 'Visitor/faqs_1.dart';

// استدعاء ملفات الأمن (Security)
import 'Security/home_page2.dart';
//import 'Security/profile_2.dart';
//import 'Security/edit_profile_2.dart';

void main() {
  runApp(const RushdApp());
}

class RushdApp extends StatelessWidget {
  const RushdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rushd App',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.deepPurple),

      // --- صفحات الأمن (Security) ---
      home: const SecurityDashboardPage(), // الصفحة الرئيسية للأمن
      // home: const SecurityProfilePage(), // بروفايل رجل الأمن
      // home: const EditProfilePageSecurity(), // تعديل بروفايل الأمن

      // --- صفحات الزائر (Visitor) ---
      // home: const ProfileVisitorPage(), // بروفايل الزائر
      // home: const EditProfilePage(), // تعديل بروفايل الزائر
      // home: const FAQPage(), // صفحة الأسئلة الشائعة
    );
  }
}
