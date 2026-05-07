import 'package:flutter/material.dart';
import 'package:rushd/shared/app_button.dart';
import 'package:rushd/shared/app_spacing.dart';
import 'loginPage.dart';

// Success message screen after account creation.
class Massage1 extends StatelessWidget {
  const Massage1({super.key});
// Builds the success message screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: SizedBox(
              width: 380,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF673AB7), // نفس الثيم
                    size: 100,
                  ),

                  AppSpacing.h30,

                  const Text(
                    "Your account\nwas successfully created!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1F2230),
                    ),
                  ),

                  AppSpacing.h40,

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppButton(
                      text: 'Log in now',
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}