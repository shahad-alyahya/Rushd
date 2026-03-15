import 'package:flutter/material.dart';
import 'homepage_2.dart';

void main() {
  runApp(const RushdApp());
}

class RushdApp extends StatelessWidget {
  const RushdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homepage_2.dart(),
    );
  }
}
