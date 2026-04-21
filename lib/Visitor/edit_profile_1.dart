import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final User? _currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_currentUser == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      final data = doc.data();

      if (data != null) {
        final fullName = (data['fullName'] ?? '').toString().trim();
        final parts = fullName.split(' ').where((e) => e.isNotEmpty).toList();

        _firstNameController.text = parts.isNotEmpty ? parts.first : '';
        _lastNameController.text =
            parts.length > 1 ? parts.sublist(1).join(' ') : '';
        _emailController.text = (data['email'] ?? '').toString();
        _passwordController.text = '************';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load user data: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;
    if (_currentUser == null) return;

    final fullName =
        '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
            .trim();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .update({
        'fullName': fullName,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile Updated Successfully! ✅'),
          backgroundColor: Color(0xFF673AB7),
          duration: Duration(seconds: 1),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildProfileIcon(),

                    const SizedBox(height: 32),

                    _buildField(
                      "First Name",
                      _firstNameController,
                      Icons.person_outline,
                    ),

                    const SizedBox(height: 16),

                    _buildField(
                      "Last Name",
                      _lastNameController,
                      Icons.person_outline,
                    ),

                    const SizedBox(height: 16),

                    _buildEmailField(),

                    const SizedBox(height: 16),

                    _buildPasswordField(),

                    const SizedBox(height: 38),

                    _buildSubmitButton(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileIcon() {
    return Container(
      height: 95,
      width: 95,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 2),
        color: const Color(0xFFF3F0FA),
      ),
      child: const Icon(
        Icons.person,
        size: 62,
        color: Color(0xFF2D3142),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Enter $label' : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 15),
          prefixIcon: Icon(
            icon,
            size: 22,
            color: const Color(0xFF673AB7),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFBFC3CF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFF673AB7),
              width: 1.4,
            ),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: _emailController,
        enabled: false,
        decoration: InputDecoration(
          labelText: "Email Address",
          labelStyle: const TextStyle(fontSize: 15),
          prefixIcon: const Icon(
            Icons.email_outlined,
            size: 22,
            color: Color(0xFF673AB7),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFBFC3CF)),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFBFC3CF)),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: _passwordController,
        enabled: false,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: const TextStyle(fontSize: 15),
          prefixIcon: const Icon(
            Icons.lock_outline,
            size: 22,
            color: Color(0xFF673AB7),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFBFC3CF)),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFBFC3CF)),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: 260,
      height: 52,
      child: ElevatedButton(
        onPressed: _submitData,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D3142),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Save Changes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}