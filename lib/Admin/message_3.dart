import 'package:flutter/material.dart';

// Success message page displayed after a zone is successfully deleted
class Message3Page extends StatelessWidget {
  const Message3Page({super.key});
  // Theme colors for the project
  static const Color kRushdPurple = Color(0xFF867AB9);
  static const Color kPrimaryDark = Color(0xFF010E16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
// Main success title
                  const Text(
                    'Success!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Detailed description of the action completed
                  const Text(
                    'The selected zone has been successfully purged from the administrative registry.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 60),
// Navigation button to return to the zones list
                  SizedBox(
                    width: 180,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to the previous screen
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
