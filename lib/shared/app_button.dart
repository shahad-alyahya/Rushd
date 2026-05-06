import 'package:flutter/material.dart';
import 'app_colors.dart';

/// A custom reusable button widget used across the application.
class AppButton extends StatelessWidget {
  // The text displayed inside the button.
  final String text;

  // Callback function triggered when the button is pressed.

  final VoidCallback onPressed;
  // Callback function triggered when the button is pressed.
  final bool withArrow;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.withArrow = false, // Defaults to false (no arrow).
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkButton,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        // Conditionally renders a Row with an arrow icon if [withArrow] is true, otherwise renders text only.
        child: withArrow
            ? Row(
                children: [
                  const Spacer(),

                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Color(0xff8F92B2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
