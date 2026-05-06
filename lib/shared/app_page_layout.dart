import 'package:flutter/material.dart';
import 'app_colors.dart';

/// A base layout wrapper providing a consistent safe area, padding, and max width constraints.
class AppPageLayout extends StatelessWidget {
  // The main content widget to be displayed within the layout.
  final Widget child;

  // The background color of the page. Defaults to the standard page background.
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
          // Ensures the content is scrollable and centered to handle overflow on smaller screens.
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
