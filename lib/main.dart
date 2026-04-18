import 'package:flutter/material.dart';
import 'splash_screen.dart';

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
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}