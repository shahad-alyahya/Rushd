import 'package:flutter/material.dart';
import 'package:rushd/Visitor/homepage1.dart';
import 'package:rushd/Visitor/reset_password.dart';
import 'package:rushd/Visitor/signupPage.dart';
import 'package:rushd/shared/app_button.dart';
import 'package:rushd/shared/app_colors.dart';
import 'package:rushd/shared/app_page_layout.dart';
import 'package:rushd/shared/app_spacing.dart';
import 'package:rushd/Security/home_page2.dart';
import 'package:rushd/Admin/HomePage-3.dart';
import 'package:rushd/Services/auth_service.dart';
import 'package:rushd/Visitor/verifyEmailPage.dart';

// Login screen for user authentication.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

// Releases the text controllers.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
// Builds the login screen.
  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      backgroundColor: const Color(0xffF8F8FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.h20,

          Center(
            child: Image.asset(
              'assets/images/rushd_logo.png',
              height: 170,
            ),
          ),

          AppSpacing.h40,

          const Text(
            'Sign in',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xff1F2230),
            ),
          ),

          AppSpacing.h24,

          _buildTextField(
            controller: _emailController,
            hintText: 'abc@email.com',
            prefixIcon: Icons.mail_outline,
          ),

          AppSpacing.h16,

          _buildPasswordField(),

          AppSpacing.h16,

          Row(
            children: [
              Switch(
                value: rememberMe,
                onChanged: (value) {
                  setState(() {
                    rememberMe = value;
                  });
                },
              ),
              const Text(
                'Remember Me',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2B2B2B),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPassword(),
                    ),
                  );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff7C7E86),
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.h16,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppButton(
              text: 'SIGN IN',
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;

                final error = await AuthService.instance.login(
                  email: email,
                  password: password,
                );

                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                  return;
                }

                final result =
                    await AuthService.instance.getCurrentUserRole();

                if (result == null) return;

                if (result.requiresVerification) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const VerifyEmailPage()),
                  );
                  return;
                }

                if (result.role == 'user') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage1()),
                  );
                } else if (result.role == 'security') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SecurityDashboardPage()),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminHomePage()),
                  );
                }
              },
            ),
          ),

          AppSpacing.h40,

          const Center(
            child: Text(
              'OR',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xff2B2B2B),
              ),
            ),
          ),

          const SizedBox(height: 26),

          _socialButton(
            text: 'Login with Google',
            iconText: 'G',
            iconColor: Colors.red,
            onTap: () {},
          ),

          AppSpacing.h16,

          _socialButton(
            text: 'Login with Facebook',
            iconText: 'f',
            iconColor: Colors.blue,
            onTap: () {},
          ),

          const SizedBox(height: 28),

          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignupPage(),
                  ),
                );
              },
              child: const Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff2B2B2B),
                  ),
                  children: [
                    TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(
                        color: Color(0xff8A79FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          AppSpacing.h20,
        ],
      ),
    );
  }
// Builds a reusable input field.
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xffA5A7B3),
          fontSize: 16,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xffA5A7B3),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xffE8E8EE),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xffCFCFE8),
            width: 1.3,
          ),
        ),
      ),
    );
  }
// Builds the password input field.
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: obscurePassword,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: 'Your password',
        hintStyle: const TextStyle(
          color: Color(0xffA5A7B3),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xffA5A7B3),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
          icon: Icon(
            obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: const Color(0xffA5A7B3),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xffE8E8EE),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xffCFCFE8),
            width: 1.3,
          ),
        ),
      ),
    );
  }
// Builds a social login button.
  Widget _socialButton({
    required String text,
    required String iconText,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: Color(0xffECECF2),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              iconText,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              text,
              style: const TextStyle(
                fontSize: 17,
                color: Color(0xff2B2B2B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}