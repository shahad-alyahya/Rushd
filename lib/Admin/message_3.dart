import 'package:flutter/material.dart';

/// [Message3Page] serves as a high-fidelity success confirmation screen.
/// It is contextually triggered after a record (e.g., a Zone) is successfully removed.
class Message3Page extends StatelessWidget {
  const Message3Page({super.key});

  // --- Brand Design Constants ---
  static const Color kRushdPurple = Color(
    0xFF867AB9,
  ); // Unified Signature Purple
  static const Color kPrimaryDark = Color(0xFF010E16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            // Maintains the 380px width to ensure a consistent iPhone aesthetic on Windows
            width: 380,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- Success Visual Indicator ---
                  // Features a drop shadow for a modern, elevated UI feel
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: kRushdPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x33867AB9),
                          blurRadius: 25,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 75,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 45),

                  // --- Feedback Content ---
                  const Text(
                    'Success!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'The selected zone has been successfully purged from the administrative registry.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.6, // Improved leading for better readability
                    ),
                  ),

                  const SizedBox(height: 60),

                  // --- Navigation Action ---
                  SizedBox(
                    width: 180,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigates back to the preceding list view
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRushdPurple,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Back to List',
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
