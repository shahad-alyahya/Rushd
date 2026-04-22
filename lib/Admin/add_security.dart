

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSecurity extends StatefulWidget {
  const AddSecurity({super.key});

  @override
  State<AddSecurity> createState() => _AddSecurityState();
}

class _AddSecurityState extends State<AddSecurity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const Color kRushdPurple = Color(0xFF867AB9);
  static const Color kFieldBorder = Color(0xFF353841);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedLocationId;
  bool _isLoadingLocations = true;
  bool _isSaving = false;

  List<Map<String, String>> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    try {
      final snapshot = await _firestore.collection('locations').get();

      final loadedLocations = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': (data['locationName'] ?? doc.id).toString(),
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        _locations = loadedLocations;
        _isLoadingLocations = false;

        if (loadedLocations.isNotEmpty) {
          _selectedLocationId = loadedLocations.first['id'];
        }
      });
    } catch (e) {
      debugPrint('Error loading locations: $e');

      if (!mounted) return;
      setState(() {
        _isLoadingLocations = false;
      });
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

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLocationId == null) return;

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final fullName = '$firstName $lastName'.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      setState(() => _isSaving = true);

      final existingUser = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This email is already registered')),
        );
        return;
      }

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

      await user.updateDisplayName(fullName);

      await _firestore.collection('users').doc(user.uid).set({
        'assignedLocationId': _selectedLocationId,
        'createdAt': FieldValue.serverTimestamp(),
        'email': email,
        'fullName': fullName,
        'isVerified': user.emailVerified,
        'role': 'security',
        'status': 'active',
      });

      await user.sendEmailVerification();

      if (!mounted) return;
      setState(() => _isSaving = false);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
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
                      _buildLocationDropdown(),

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

  Widget _buildLocationDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 0.8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: _isLoadingLocations
          ? const SizedBox(
              height: 52,
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLocationId,
                isExpanded: true,
                hint: const Text('Select Location'),
                items: _locations
                    .map(
                      (loc) => DropdownMenuItem<String>(
                        value: loc['id'],
                        child: Text(loc['name']!),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLocationId = value;
                  });
                },
              ),
            ),
    );
  }
}