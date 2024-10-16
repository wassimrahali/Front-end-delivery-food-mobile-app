import 'dart:convert';
import 'package:Foodu/screens/Home.dart';
import 'package:Foodu/auth/SignUpForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/colors.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  String? phone;
  String? password;

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
                      "Login to Your Account",
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
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          phone = value; // Store the phone number
                        },
                      ),
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
                            borderSide: BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          password = value; // Store the password
                        },
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () async {
                          // Validate the form and perform login if valid
                          if (_formKey.currentState!.validate()) {
                            await login(phone!, password!); // Call the login function
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
                              "Sign In",
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
                      TextDivider(text: "Or continue with"),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset("assets/images/facebook.png", width: 30),
                          Image.asset("assets/images/google.png", width: 30),
                          Image.asset("assets/images/apple.png", width: 30),
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpForm()));
                            },
                            child: Text(
                              " Sign up",
                              style: TextStyle(color: disabledButtonColor, fontFamily: "Urbanist-SemiBold"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
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

  Future<void> login(String phone, String password) async {
    final String apiUrl = 'http://192.168.146.42:8000/api/auth/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Assuming the response body contains a JSON object with user details
        final responseData = jsonDecode(response.body);
        print('Login successful: ${responseData}');

        // Navigate to home screen or perform any other action
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        // Handle login failure
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse['message'] ?? 'Login failed';
        print('Login failed: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      // Handle any errors during login
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }
}

class TextDividerWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double thickness;
  final Color color;

  const TextDividerWidget({
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
              fontFamily: 'Urbanist-SemiBold',
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
