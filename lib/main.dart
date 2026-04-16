import 'package:flutter/material.dart';
import 'package:rushd/map/testAreaPage.dart';


void main() {
  runApp(const RushdApp());
}

class RushdApp extends StatelessWidget {
  const RushdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestAreaPage(),
    );
  }
}