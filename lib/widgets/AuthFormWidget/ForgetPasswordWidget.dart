import 'package:Foodu/auth/Userauth/ForgetPassword.dart';
import 'package:flutter/material.dart';
import 'package:Foodu/utils/colors.dart';
class Forgetpasswordwidget extends StatefulWidget {
  const Forgetpasswordwidget({super.key});

  @override
  State<Forgetpasswordwidget> createState() => _ForgetpasswordwidgetState();
}

class _ForgetpasswordwidgetState extends State<Forgetpasswordwidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Forgetpassword()));
            },
            child: const Text(
              " Forget Your Password? ",
              style: TextStyle(color: successColor, fontFamily: "Urbanist-SemiBold"), // Replace with your disabledButtonColor variable
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
  }
}
