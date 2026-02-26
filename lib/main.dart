import 'package:flutter/material.dart';

void main() => runApp(const RushdApp());

class RushdApp extends StatelessWidget {
  const RushdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rushd',
      home: const Scaffold(
        body: Center(child: Text('Rushd App Started 🚀')),
      ),
    );
  }
}