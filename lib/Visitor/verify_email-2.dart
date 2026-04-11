import 'package:flutter/material.dart';
import 'package:rushd/shared/app_button.dart';
import 'package:rushd/shared/app_spacing.dart';
import 'create_password.dart';

class Verification extends StatelessWidget {
  const Verification({super.key});

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
                    "Verification",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1F2230),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "We've send you the verification\ncode on abc@email.com",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF120D26),
                      height: 1.5,
                    ),
                  ),

                  AppSpacing.h40,

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OtpBox(),
                      OtpBox(),
                      OtpBox(),
                      OtpBox(),
                    ],
                  ),

                  const SizedBox(height: 42),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppButton(
                      text: 'CONTINUE',
                      withArrow: true,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreatePassword(),
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
}

class OtpBox extends StatelessWidget {
  const OtpBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE4E4E4),
          width: 1.5,
        ),
      ),
      child: const Text(
        "-",
        style: TextStyle(
          fontSize: 24,
          color: Color(0xFFD9D9D9),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}