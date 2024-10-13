import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class SignupScreen extends StatefulWidget {

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: grayScale, size: 26),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 35),
                    Image.asset('assets/images/logo1.png'),
                    SizedBox(height: 15),
                    Text(
                      "Create New Account",
                      style: TextStyle(
                        color: grayScale,
                        fontFamily: "Urbanist-SemiBold",
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: CupertinoColors.black,
                        decoration: InputDecoration(
                          hintText: "Phone Number",
                          hintStyle: TextStyle(fontSize: 13, fontFamily: 'Urbanist-Regular'),
                          prefixIcon: Icon(Icons.phone_android_rounded),
                          filled: true,
                          fillColor: Colors.grey[100],
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),


                      SizedBox(height: 20),
                      TextFormField(
                        cursorColor: CupertinoColors.black,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",

                          hintStyle: TextStyle(fontSize: 13, fontFamily: 'Urbanist-Regular'),
                          prefixIcon: Icon(Icons.password_sharp),
                          filled: true,
                          fillColor: Colors.grey[100],
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green, width: 2.0,),
                            borderRadius: BorderRadius.circular(20.0),

                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40),


                      ElevatedButton(
                        onPressed: () {
                          // Add your onPressed functionality here
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, process the data
                            print('Form is valid');
                          }
                        },
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
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,

                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      TextDivider(text: "Or continue with",),
                      SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset("assets/images/facebook.png",width: 30,),
                          Image.asset("assets/images/google.png",width: 30,),
                          Image.asset("assets/images/apple.png",width: 30,),
                        ],
                      ),
                      SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(fontFamily: "Urbanist-SemiBold"),
                            textAlign: TextAlign.center,
                          ),
                          InkWell(
                            onTap: () {
                              // Handle sign-in tap here
                              print("Sign in tapped");
                              // You can navigate to the sign-in screen or perform any action here
                            },
                            child: Text(
                              " Sign in",
                              style: TextStyle(color: disabledButtonColor, fontFamily: "Urbanist-SemiBold"),
                              textAlign: TextAlign.center,
                            ),
                          )

                        ],
                      )



                    ],

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class TextDivider extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double thickness;
  final Color color;

  const TextDivider({
    Key? key,
    required this.text,
    this.textStyle,
    this.thickness = 1.5,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: thickness,
            color: color,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            style: textStyle ?? TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontFamily: 'Urbanist-SemiBold'
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: thickness,
            color: color,
          ),
        ),
      ],
    );
  }

}

