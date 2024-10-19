import 'package:Foodu/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:Foodu/auth/Userauth/SignUpForm.dart';

class SignUpOptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(fontFamily: "Urbanist-SemiBold"),
          textAlign: TextAlign.center,
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpForm()));
          },
          child: Text(
            " Sign up",
            style: TextStyle(color: successColor, fontFamily: "Urbanist-SemiBold"), // Replace with your disabledButtonColor variable
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
