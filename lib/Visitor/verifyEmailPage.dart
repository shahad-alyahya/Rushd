import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rushd/Services/auth_service.dart';
import 'homepage1.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // يبدأ التشييك كل 3 ثواني
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await AuthService.instance.reloadCurrentUser();
      final result = await AuthService.instance.getCurrentUserRole();

      if (result == null) return;

      if (!result.requiresVerification) {
        _timer?.cancel();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage1()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> resendEmail() async {
    await AuthService.instance.sendVerificationEmail();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Verification email sent")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Verify Your Email",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "We sent a verification link to your email.\n\nWaiting for verification...",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              const CircularProgressIndicator(),

              const SizedBox(height: 20),

              TextButton(
                onPressed: resendEmail,
                child: const Text("Resend Email"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}