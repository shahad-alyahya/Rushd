import 'package:flutter/material.dart';

/// [Message4] serves as the success confirmation for user-related administrative tasks.
/// Standardized with Rushd branding (Purple) and a 380px container for cross-platform alignment.
class Message4 extends StatelessWidget {
  const Message4({super.key});

  // --- Branding Constants ---
  static const Color kRushdPurple = Color(0xFF867AB9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380, // Aligned with the rest of the app's components
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- Success Icon Container ---
                  Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      color: kRushdPurple, // Updated to brand color
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x33867AB9),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- Narrative Feedback ---
                  const Text(
                    'User deleted successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF010E16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'The security personnel has been removed from the registry.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),

                  const SizedBox(height: 80),

                  // --- Navigation Action ---
                  SizedBox(
                    width: 180,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRushdPurple,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
