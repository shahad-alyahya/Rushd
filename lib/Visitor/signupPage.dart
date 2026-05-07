import 'package:flutter/material.dart';
import 'package:rushd/shared/app_button.dart';
import 'package:rushd/shared/app_page_layout.dart';
import 'verifyEmailPage.dart';
import 'package:rushd/Services/auth_service.dart';
import 'loginPage.dart';

// Sign up screen for creating a new account.
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

// Builds the sign up screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppPageLayout(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                ),

                const SizedBox(height: 10),

                Center(
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/rushd_logo.png',
                          height: 200, 
                          fit: BoxFit.contain, 
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                _field(_fullNameController, "Full Name"),
                const SizedBox(height: 15),
                _field(_emailController, "Email"),
                const SizedBox(height: 15),
                _field(_passwordController, "Password", isPassword: true),
                const SizedBox(height: 15),
                _field(
                  _confirmPasswordController,
                  "Confirm Password",
                  isPassword: true,
                ),

                const SizedBox(height: 25),

                AppButton(
                  text: "Sign Up",
                  onPressed: () async {
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }

                    final error = await AuthService.instance.signUpUser(
                      fullName: _fullNameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    if (error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));
                      return;
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VerifyEmailPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Builds a reusable input field.
  Widget _field(
    TextEditingController c,
    String hint, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: c,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF867AB9), width: 2),
        ),
      ),
    );
  }
}
