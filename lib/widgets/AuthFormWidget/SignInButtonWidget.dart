import 'package:flutter/material.dart';

class SignInButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text; // Add this line to declare the text variable

  // Include the text parameter in the constructor
  SignInButtonWidget({required this.onPressed, required this.text});

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
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Container(
          constraints: BoxConstraints(minWidth: 200, minHeight: 56),
          alignment: Alignment.center,
          child: Text(
            text, // Now using the passed text variable
            style: TextStyle(
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
