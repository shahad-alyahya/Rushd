import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'security_bottom_bar.dart';

class EditProfilePageSecurity extends StatefulWidget {
  const EditProfilePageSecurity({super.key});

  @override
  State<EditProfilePageSecurity> createState() =>
      _EditProfilePageSecurityState();
}

class _EditProfilePageSecurityState extends State<EditProfilePageSecurity> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final User? _currentUser = FirebaseAuth.instance.currentUser;

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

        // مجرد عرض شكلي، بدون تحديث فعلي للباسوورد
        _passwordController.text = '************';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _processProfileUpdate() async {
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
          content: Text('Profile Updated Successfully!'),
          backgroundColor: Color(0xFF867AB9),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update failed: $e'),
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
      appBar: AppBar(
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
            width: 380,
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
                            enabled: false,
                          ),
                          const SizedBox(height: 20),

                          _buildCustomTextField(
                            "Password",
                            _passwordController,
                            Icons.lock_outline,
                            isObscured: true,
                            enabled: false,
                          ),

                          const SizedBox(height: 50),
                          _buildSaveActionBtn(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SecurityBottomBar(currentIndex: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildCustomTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isObscured = false,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      enabled: enabled,
      validator: (val) {
        if (!enabled) return null;
        return (val == null || val.isEmpty) ? 'This field is required' : null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF867AB9)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFBFC3CF)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFBFC3CF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF867AB9), width: 2),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade100,
      ),
    );
  }

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