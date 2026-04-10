import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // 1. مفتاح للفورم عشان نتحقق من البيانات (Validation)

  final _formKey = GlobalKey<FormState>();

  // 2. كونتولرز لاستقبال الكتابة

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  // ميثود الإرسال

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile Updated Successfully! ✅'),

          backgroundColor: Color(0xFF673AB7),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.symmetric(horizontal: 30),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              const Center(
                child: Text(
                  'Edit Profile',

                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 30),

              _buildProfileIcon(),

              const SizedBox(height: 40),

              _buildField(
                "First Name",

                _firstNameController,

                Icons.person_outline,
              ),

              const SizedBox(height: 20),

              _buildField(
                "Last Name",

                _lastNameController,

                Icons.person_outline,
              ),

              const SizedBox(height: 20),

              _buildEmailField(),

              const SizedBox(height: 20),

              _buildField(
                "Password",

                _passwordController,

                Icons.lock_outline,

                isPass: true,
              ),

              const SizedBox(height: 50),

              _buildSubmitButton(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileIcon() {
    return Center(
      child: Container(
        height: 110,

        width: 110,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          border: Border.all(color: Colors.grey.shade200, width: 3),

          color: const Color(0xFFF3F0FA),
        ),

        child: const Icon(Icons.person, size: 75, color: Color(0xFF2D3142)),
      ),
    );
  }

  Widget _buildField(
    String label,

    TextEditingController controller,

    IconData icon, {

    bool isPass = false,
  }) {
    return TextFormField(
      controller: controller,

      obscureText: isPass,

      validator: (value) =>
          (value == null || value.isEmpty) ? 'Enter $label' : null,

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(icon, color: const Color(0xFF673AB7)),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),

        filled: true,

        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,

      validator: (value) {
        if (value == null || !value.contains('@') || !value.contains('.')) {
          return 'Enter a valid email';
        }

        return null;
      },

      decoration: InputDecoration(
        labelText: "Email Address",

        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF673AB7)),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),

        filled: true,

        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,

      height: 55,

      child: ElevatedButton(
        onPressed: _submitData,

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D3142),

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
