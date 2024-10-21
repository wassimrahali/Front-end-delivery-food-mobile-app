import 'package:Foodu/utils/colors.dart'; // Assuming successColor is defined here
import 'package:flutter/material.dart';

class SignInButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  // Constructor with required text and onPressed parameters
  const SignInButtonWidget({
    required this.onPressed,
    required this.text,
    Key? key,
  }) : super(key: key); // Use super to pass the key to the parent class

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: successColor, // Assuming successColor is defined in your colors file
          borderRadius: BorderRadius.circular(28),
        ),
        child: Container(
          constraints: const BoxConstraints(minWidth: 200, minHeight: 56),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
