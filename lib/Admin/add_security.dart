import 'package:flutter/material.dart';

/// [AddSecurity] provides an administrative interface for onboarding new security personnel.
/// Features high-level form validation, data integrity checks, and credential masking.
class AddSecurity extends StatefulWidget {
  const AddSecurity({super.key});

  @override
  State<AddSecurity> createState() => _AddSecurityState();
}

class _AddSecurityState extends State<AddSecurity> {
  // Global key for identifying the form and triggering validation logic
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Branding constants for UI consistency
  static const Color kRushdPurple = Color(0xFF867AB9);
  static const Color kFieldBorder = Color(0xFF353841);

  // Controllers managed as empty states to prioritize placeholders (hints)
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Memory Cleanup: Disposing controllers to optimize resource allocation
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Executes form validation and returns a personnel object upon success.
  void _handleSave() {
    // [VALIDATION ENGINE] Triggers individual field validators
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'name':
            "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
        'email': _emailController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380, // Optimized for mobile viewport scaling on desktop
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey, // Establishing the validation context
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(context),
                      const SizedBox(height: 60),

                      _buildInputLabel('First Name'),
                      const SizedBox(height: 8),
                      _buildValidatedField(
                        controller: _firstNameController,
                        hint: 'Fahad', // Transparent placeholder
                        validator: (val) => (val == null || val.isEmpty)
                            ? 'Please enter first name'
                            : null,
                      ),

                      const SizedBox(height: 18),
                      _buildInputLabel('Last Name'),
                      const SizedBox(height: 8),
                      _buildValidatedField(
                        controller: _lastNameController,
                        hint: 'Mohammed',
                        validator: (val) => (val == null || val.isEmpty)
                            ? 'Please enter last name'
                            : null,
                      ),

                      const SizedBox(height: 18),
                      _buildInputLabel('Email Address'),
                      const SizedBox(height: 8),
                      _buildValidatedField(
                        controller: _emailController,
                        hint: 'fahad@example.com',
                        keyboardType: TextInputType.emailAddress,
                        // [EMAIL VALIDATION] Enforcing strict character inclusion (@)
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'Email is required';
                          if (!val.contains('@'))
                            return 'Please enter a valid email containing @';
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),
                      _buildInputLabel('Security Password'),
                      const SizedBox(height: 8),
                      _buildValidatedField(
                        controller: _passwordController,
                        hint: '', // Starts empty as requested
                        isObscure: true, // Conceals characters as dots/stars
                        validator: (val) => (val == null || val.isEmpty)
                            ? 'Password is required'
                            : null,
                      ),

                      const SizedBox(height: 50),

                      Center(
                        child: SizedBox(
                          width: 160,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kFieldBorder,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 2,
                            ),
                            onPressed: _handleSave,
                            child: const Text(
                              'Save Personnel',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        const SizedBox(width: 5),
        const Text(
          'Add Security',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String text) => Text(
    text,
    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  );

  /// Generates a standardized text field with context-specific validation and placeholder support.
  Widget _buildValidatedField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint, // Visual example text
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 14),
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kRushdPurple, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}
