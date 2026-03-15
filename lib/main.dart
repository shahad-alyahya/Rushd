import 'package:flutter/material.dart';
// نستخدم المسار الصحيح للمجلد والملف
import 'Security/homepage_2.dart';

void main() {
  runApp(const RushdApp());
}

class RushdApp extends StatelessWidget {
  const RushdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rushd App',
      // إخفاء شريط الـ Debug المزعج
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // ننادي كلاس HomePage2 اللي موجود في ملف homepage_2.dart
      home: const HomePage2(),
    );
  }
}
