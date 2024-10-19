import 'package:flutter/material.dart';

class SocialMediaIconsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset("assets/images/facebook.png", width: 30),
        Image.asset("assets/images/google.png", width: 30),
        Image.asset("assets/images/apple.png", width: 30),
      ],
    );
  }
}
