import 'package:flutter/material.dart';

/// A custom reusable text field widget with built-in validation and styling.
class AppTextField extends StatelessWidget {
  /// A custom reusable text field widget with built-in validation and styling.
  final String label;

  // The prefix icon displayed on the left side.
  final IconData icon;

  // Controller to manage and retrieve the text input.
  final TextEditingController controller;

  // Determines if the input should be obscured (e.g., for passwords).
  final bool isPassword;

  const AppTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,

      // Basic validation to ensure the field is not empty.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter $label';
        }
        return null;
      },

      style: const TextStyle(fontSize: 16),

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(icon, color: const Color(0xFF673AB7), size: 22),

        filled: true,
        fillColor: const Color(0xFFF7F7F9),

        //  Adjusts the internal padding to control the visual height of the text field.
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF673AB7), width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}
