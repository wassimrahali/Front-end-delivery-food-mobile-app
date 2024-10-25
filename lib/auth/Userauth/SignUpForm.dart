import 'package:Foodu/services/UserService/signup_service.dart';
import 'package:Foodu/widgets/AuthFormWidget/SocialMediaIconsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Foodu/auth/Userauth/SignInForm.dart';
import 'package:Foodu/utils/colors.dart';

import '../../widgets/AuthFormWidget/HeaderWidget.dart';
import '../../widgets/AuthFormWidget/TextDivderWidget.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    HeaderWidget("Login", text: 'Create New Account',),
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
                            // Call the signUp method from SignUpService
                            SignUpService.signUp(
                              _nameController.text,
                              _emailController.text,
                              _phoneController.text,
                              _passwordController.text,
                              context,
                            );
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
                      TextDividerWidget(text: "Or continue with"),
                      SizedBox(height: 20),
                      SocialMediaIconsWidget(),
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInForm()));
                            },
                            child: Text(
                              " Sign in",
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
