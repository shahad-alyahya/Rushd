import 'package:flutter/material.dart';

class Verification extends StatelessWidget {
  const Verification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              
               Transform.translate(
              offset: const Offset(-10,8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 26, color: Colors.black),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              ),

              const SizedBox(height: 18),

              Transform.translate(
                offset: const Offset(38,0),
              child: const Text(
                "Verification",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF120D26),
                ),
              ),
              ),
              const SizedBox(height: 0),

              Transform.translate(
                offset: const Offset(38,0),
              child: const Text(
                "We've send you the verification\ncode on abc@email.com",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black,
                ),
              ),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  OtpBox(),
                  SizedBox(width:22),
                  OtpBox(),
                  SizedBox(width:22),
                  OtpBox(),
                  SizedBox(width:22),
                  OtpBox(),
                ],
              ),

              const SizedBox(height: 42),

              Center(
                child: Container(
                  width: 271,
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF353841),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      const Text(
                        "CONTINUE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7B7F9A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: "Re-send code in ",style: TextStyle(color: Color(0xFF120D26))),
                      TextSpan(
                        text: " 0:20",
                        style: TextStyle(color: Color(0XFF7B7F9A)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpBox extends StatelessWidget {
  final bool isFocused;

  const OtpBox({
    super.key,
    this.isFocused = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFocused ? const Color(0xFF7A73D1) : const Color(0xFFE4E4E4),
          width: isFocused ? 2 : 1.5,
        ),
      ),
      child: Text(
        "-",
        style: TextStyle(
          fontSize: 24,
          color: isFocused ? const Color(0xFF7A73D1) : const Color(0xFFD9D9D9),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}