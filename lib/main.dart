import 'package:flutter/material.dart';
import 'Admin/HomePage-3.dart';

void main() {
  runApp(const RushdApp());
}

class RushdApp extends StatelessWidget {
  const RushdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 401,
            height: 874,
            child: const HomePage3Screen(),
          ),
        ),
      ),
    );
  }
}