import 'package:flutter/material.dart';

// استدعاء ملفات الزائر (Visitor)
import 'Visitor/profile_1.dart';
import 'Visitor/edit_profile_1.dart';
import 'Visitor/faqs_1.dart';

// استدعاء ملفات الأمن (Security)
import 'Security/home_page2.dart';
import 'Security/profile_2.dart';
import 'Security/edit_profile_2.dart';

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

      /* يا لولو، اختاري الصفحة اللي تبينها تظهر أول ما يشتغل التطبيق 
         عن طريق تفعيل سطر واحد فقط من الأسطر اللي تحت (امسحي //):
      */

      // --- صفحات الأمن (Security) ---
      home:
          const SecurityDashboardPage(), // الصفحة الرئيسية للأمن [cite: 170, 171]
      // home: const SecurityProfilePage(), // بروفايل رجل الأمن [cite: 351, 352]
      // home: const EditProfilePageSecurity(), // تعديل بروفايل الأمن [cite: 5, 6]

      // --- صفحات الزائر (Visitor) ---
      // home: const ProfileVisitorPage(), // بروفايل الزائر [cite: 796, 797]
      // home: const EditProfilePage(), // تعديل بروفايل الزائر [cite: 501, 502]
      // home: const FAQPage(), // صفحة الأسئلة الشائعة [cite: 661, 662]
    );
  }
}
