import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

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

              // title
              Transform.translate(
                offset: const Offset(38,0),
              child: const Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF120D26),
                  fontWeight: FontWeight.w600,
                ),
              ),
              ),
              const SizedBox(height: 12),

              Transform.translate(
                offset: const Offset(38,0),
              child: const Text(
                "Please enter your email address to\nrequest a password reset",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF120D26),
                ),
              ),
              ),
              const SizedBox(height: 40),

              // email field
              Center(
                child: Container(
                width: 317,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                 height: 56,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFFE4DFDF),
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
                            color: Color(0xFF747688)
                            ),
                          
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ),
              const SizedBox(height: 42),

              // SEND button
              Center(
  child: Container(
    width: 271,
    height: 58,
    decoration: BoxDecoration(
      color: const Color(0xFF353841),
      borderRadius: BorderRadius.circular(15),
    ),
    alignment: Alignment.center,
    child: const Text(
      "SEND",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
)
                 
            ],
          ),
        ),
      ),
    );
  }
}