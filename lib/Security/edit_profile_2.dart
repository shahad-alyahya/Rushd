import 'package:flutter/material.dart';
import 'security_bottom_bar.dart';

class EditProfilePageSecurity extends StatefulWidget {
  const EditProfilePageSecurity({super.key});

  @override
  State<EditProfilePageSecurity> createState() =>
      _EditProfilePageSecurityState();
}

class _EditProfilePageSecurityState extends State<EditProfilePageSecurity> {
  // Key for form validation logic
  final _formKey = GlobalKey<FormState>();

  // Input controllers to manage user text data
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Core function to handle database update simulation and UI refresh
  Future<void> _processProfileUpdate() async {
    // Validates the form state before proceeding
    if (_formKey.currentState!.validate()) {
      // Logic: Simulating network latency for database update
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        // UI Feedback: Notifying user of successful update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile Updated Successfully! '),
            backgroundColor: Color(0xFF867AB9),
          ),
        );
        // Navigates back to the main profile page to reflect changes
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Standard iOS-style back button for intuitive navigation
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380, // Consistent container width for cross-device symmetry
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildProfileHeroIcon(),
                          const SizedBox(height: 40),

                          // Standardized Input Fields with Validation
                          _buildCustomTextField(
                            "First Name",
                            _firstNameController,
                            Icons.person_outline,
                          ),
                          const SizedBox(height: 20),
                          _buildCustomTextField(
                            "Last Name",
                            _lastNameController,
                            Icons.person_outline,
                          ),
                          const SizedBox(height: 20),
                          _buildCustomTextField(
                            "Email Address",
                            _emailController,
                            Icons.email_outlined,
                          ),
                          const SizedBox(height: 20),
                          _buildCustomTextField(
                            "Password",
                            _passwordController,
                            Icons.lock_outline,
                            isObscured: true,
                          ),

                          const SizedBox(height: 50),
                          _buildSaveActionBtn(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                // Keeps the bottom bar active even during edit for navigation availability
                const SecurityBottomBar(currentIndex: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Component: The decorative security icon for the edit screen
  Widget _buildProfileHeroIcon() {
    return Container(
      height: 110,
      width: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF3F0FA),
        border: Border.all(color: Colors.grey.shade100, width: 3),
      ),
      child: const Icon(Icons.security, size: 70, color: Color(0xFF867AB9)),
    );
  }

  // Helper: Generates uniform text fields with built-in validation
  Widget _buildCustomTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isObscured = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      validator: (val) =>
          (val == null || val.isEmpty) ? 'This field is required' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF867AB9)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF867AB9), width: 2),
        ),
      ),
    );
  }

  // Component: The primary submit button for the form
  Widget _buildSaveActionBtn() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _processProfileUpdate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF867AB9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Save Changes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
