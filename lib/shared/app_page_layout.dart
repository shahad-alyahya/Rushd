import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppPageLayout extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const AppPageLayout({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.pageBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}