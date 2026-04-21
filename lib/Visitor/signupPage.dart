import 'package:flutter/material.dart';
import 'package:rushd/shared/app_button.dart';
import 'package:rushd/shared/app_page_layout.dart';
import 'package:rushd/shared/app_spacing.dart';
import 'verifyEmailPage.dart';
import 'package:rushd/Services/auth_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      child: Column(
        children: [
          _field(_fullNameController, "Full Name"),
          _field(_emailController, "Email"),
          _field(_passwordController, "Password"),
          _field(_confirmPasswordController, "Confirm Password"),

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
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error)));
                return;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const VerifyEmailPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String hint) {
    return TextField(controller: c, decoration: InputDecoration(hintText: hint));
  }
}