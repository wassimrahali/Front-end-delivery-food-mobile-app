import 'dart:convert';
import 'package:Foodu/screens/HomeScreen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:Foodu/auth/SignInForm.dart';
import 'package:Foodu/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each input field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signUp(BuildContext context) async {
    final url = Uri.parse('http://192.168.146.42:8000/api/auth/register');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Sign Up successful: ${responseData['message']}');

      // Navigate to the login page on success


    } else {
      final errorResponse = jsonDecode(response.body);
      String errorMessage = errorResponse['message'] ?? 'Sign up sucessufully ';
      print('Sign Up failed: $errorMessage');
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SignInForm())
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

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
                      _buildTextFormField(
                        controller: _nameController,
                        hintText: "Full Name",
                        icon: Icons.account_circle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _emailController,
                        hintText: "Email",
                        icon: Icons.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _phoneController,
                        hintText: "Phone Number",
                        icon: Icons.phone_android_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _passwordController,
                        hintText: "Password",
                        icon: Icons.password_sharp,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signUp(context);  // Pass context to sign-up function
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
                      SizedBox(height: 20),
                      TextDivider(text: "Or continue with",),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset("assets/images/facebook.png", width: 30,),
                          Image.asset("assets/images/google.png", width: 30,),
                          Image.asset("assets/images/apple.png", width: 30,),
                        ],
                      ),
                      SizedBox(height: 20),
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
                              // Navigate to sign-in page
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInForm(),));
                            },
                            child: Text(
                              " Sign in",
                              style: TextStyle(color: disabledButtonColor, fontFamily: "Urbanist-SemiBold"),
                              textAlign: TextAlign.center,
                            ),

                          ),
                          InkWell(
                            onTap: () {
                              // Navigate to sign-in page
                              Get.to(Homescreen());
                            },
                            child: Text(
                              " home",
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: CupertinoColors.black,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 13, fontFamily: 'Urbanist-Regular'),
        prefixIcon: Icon(icon),
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
      validator: validator,
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
