import 'package:flutter/material.dart';
// Import واجهتنا اللي تعبنا عليها
import 'package:rushd/Security/homepage_2.dart';

void main() {
  runApp(const RushdApp());
}

class RushdApp extends StatelessWidget {
  const RushdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rushd',
      // هنا نادينا HomePage2 حقتنا
      home: HomePage2(),
    );
  }
}
