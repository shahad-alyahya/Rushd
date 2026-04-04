import 'package:flutter/material.dart';

class AddSecurity extends StatelessWidget {
  const AddSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SizedBox(
          width: 401,
          height: 874,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),

                /// status bar
                
                const SizedBox(height: 28),

                /// top row
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Color(0xFF010E16),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Add Security',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF010E16),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 92),

                const _FieldLabel(text: 'First Name'),
                const SizedBox(height: 8),
                const _CustomField(initialText: 'Fahad'),

                const SizedBox(height: 18),

                const _FieldLabel(text: 'Last Name'),
                const SizedBox(height: 8),
                const _CustomField(initialText: 'Mohammed'),

                const SizedBox(height: 18),

                const _FieldLabel(text: 'Email'),
                const SizedBox(height: 8),
                const _CustomField(initialText: 'Fahadmohammed@gmail.com'),

                const SizedBox(height: 18),

                const _FieldLabel(text: 'Password'),
                const SizedBox(height: 8),
                const _CustomField(initialText: '************'),

                const SizedBox(height: 56),

                Center(
                  child: SizedBox(
                    width: 156,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF353841),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Color(0xFF010E16),
      ),
    );
  }
}

class _CustomField extends StatelessWidget {
  final String initialText;

  const _CustomField({required this.initialText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: TextField(
        controller: TextEditingController(text: initialText),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF010E16),
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF353841),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF353841),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}