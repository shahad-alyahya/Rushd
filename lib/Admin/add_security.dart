import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSecurity extends StatefulWidget {
  final String selectedLocationId;
  final String selectedLocationName;

  const AddSecurity({
    super.key,
    required this.selectedLocationId,
    required this.selectedLocationName,
  });

  @override
  State<AddSecurity> createState() => _AddSecurityState();
}

class _AddSecurityState extends State<AddSecurity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const Color kRushdPurple = Color(0xFF867AB9);
  static const Color kFieldBorder = Color(0xFF353841);
 // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Controllers for input fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    // Dispose controllers to free up memory
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
// save or reactivate security staff
  Future<void> _handleSave() async {
    // Validate form inputs before proceeding
    if (!_formKey.currentState!.validate()) return;

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final fullName = '$firstName $lastName'.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      setState(() => _isSaving = true);
// Check if a user with this email already exists in Firestore
      final existingUser = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

     if (existingUser.docs.isNotEmpty) {
  final doc = existingUser.docs.first;
  final data = doc.data();
  final status = (data['status'] ?? 'active').toString();
// If user exists but is inactive, reactivate them and update details
  if (status == 'inactive') {
    await doc.reference.update({
      'status': 'active',
      'fullName': fullName,
      'assignedLocationId': widget.selectedLocationId,
    });

    if (!mounted) return;
    setState(() => _isSaving = false);

    Navigator.pop(context);
    return;
  } else {
    // If user is already active, show error
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This email is already registered')),
    );
    return;
  }
}
// Create a new user in Firebase Authentication
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        return;
      }
// Update the user's display name in Firebase Auth
      await user.updateDisplayName(fullName);

      await _firestore.collection('users').doc(user.uid).set({
        'assignedLocationId': widget.selectedLocationId,
        'createdAt': FieldValue.serverTimestamp(),
        'email': email,
        'fullName': fullName,
        'isVerified': user.emailVerified,
        'role': 'security',
        'status': 'active',
      });
// Send verification email to the new user
      await user.sendEmailVerification();

      if (!mounted) return;
      setState(() => _isSaving = false);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase specific errors (email in use, etc.)
      if (!mounted) return;
      setState(() => _isSaving = false);

      String message = 'Failed to save security staff';

      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email';
      } else if (e.code == 'weak-password') {
        message = 'Password should be at least 6 characters';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      debugPrint('Error saving security staff: $e');
      if (!mounted) return;
      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save security staff')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(context),
                      const SizedBox(height: 50),

                      _buildInputLabel('First Name'),
                      const SizedBox(height: 8),
                      _buildValidatedField(
                        controller: _firstNameController,
                        hint: 'Fahad',
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'Please enter first name'
                            : null,
                      ),

                      const SizedBox(height: 18),
                      _buildInputLabel('Last Name'),
                      const SizedBox(height: 8),
                      _buildValidatedField(
                        controller: _lastNameController,
                        hint: 'Mohammed',
                        validator: (val) => (val == null || val.trim().isEmpty)
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
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!val.contains('@')) {
                            return 'Please enter a valid email containing @';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),
                      _buildInputLabel('Security Password'),
                      const SizedBox(height: 8),
                      _buildValidatedField(
                        controller: _passwordController,
                        hint: '',
                        isObscure: true,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Password is required';
                          }
                          if (val.trim().length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),
                      _buildInputLabel('Location'),
                      const SizedBox(height: 8),
                      _buildLocationField(),

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
                            onPressed: _isSaving ? null : _handleSave,
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
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
// Header widget with back button
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
// Reusable validated text field widget
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
        hintText: hint,
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
  Widget _buildLocationField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 0.8),
        color: Colors.white,
      ),
      child: Text(
        widget.selectedLocationName,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}