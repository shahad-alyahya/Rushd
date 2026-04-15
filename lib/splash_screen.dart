import 'package:flutter/material.dart';
// import 'package:rushd/Security/home_page2.dart'; // [DEPRECATED] Original destination commented out
//import 'package:rushd/Admin/HomePage-3.dart'; // [UPDATED] Redirecting to Admin Dashboard
import 'package:rushd/Visitor/loginPage.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // --- Animation Controller Initialization ---
    // Manages the 2-second timing for the visual entrance effects
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Opacity animation from transparent to opaque
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Scaling animation for a subtle "zoom-in" feel on the logo
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // --- Navigation Logic Implementation ---
    // Executing the transition after a 3-second delay for branding exposure
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      // Routing to the Administrative Module
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              // const SecurityDashboardPage(), // [Original Destination Commented Out]
              const LoginPage(), // [New Destination: Admin Dashboard]
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Smooth Cross-Fade transition for premium UI feel
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    // Memory Management: Disposing the controller to prevent leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8FA),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            // Rushd Branding Logo
            child: Image.asset("assets/images/rushd_logo.png", width: 230),
          ),
        ),
      ),
    );
  }
}
