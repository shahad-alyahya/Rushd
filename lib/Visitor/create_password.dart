import 'package:flutter/material.dart';

class CreatePassword extends StatelessWidget {
  const CreatePassword({super.key});

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

              const Text(
                "Create your password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 34),

              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFBFC3CF),
                    width: 1,
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          hintStyle: TextStyle(
                            color: Color(0xFFB0B4BE),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.black54,
                      size: 24,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              const PasswordRule(text: "8 characters minimum"),
              SizedBox(height: 12),
              const PasswordRule(text: "a number"),
              SizedBox(height: 12),
              const PasswordRule(text: "a symbol"),

              const SizedBox(height: 150),

              Center(
                child: Container(
                  width: 311,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF353841),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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

class PasswordRule extends StatelessWidget {
  final String text;

  const PasswordRule({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFCFCFCF),
              width: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}