import 'package:flutter/material.dart';
import 'package:rushd/shared/app_button.dart';
import 'package:rushd/shared/app_spacing.dart';
import 'verify_email-2.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 26,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1F2230),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Please enter your email address to\nrequest a password reset",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF120D26),
                    ),
                  ),

                  AppSpacing.h40,

                  _buildEmailField(),

                  const SizedBox(height: 42),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppButton(
                      text: 'SEND',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Verification(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Center(
                    child: Text(
                      "Re-send code in 0:20",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7B7F9A),
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

  Widget _buildEmailField() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE4DFDF),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.mail_outline, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "abc@email.com",
                hintStyle: TextStyle(
                  color: Color(0xFF747688),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}