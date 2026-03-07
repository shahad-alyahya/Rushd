import 'package:flutter/material.dart';
import 'SecurityStaff/ZoneAlerts-2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ZoneAlerts2Screen(),
    );
  }
}