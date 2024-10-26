import 'package:Foodu/services/UserService/ForgetPosswordService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/AuthFormWidget/HeaderWidget.dart';

class updatePassword extends StatefulWidget {
  final String email;

  const updatePassword({super.key, required this.email});
  @override
  State<updatePassword> createState() => _updatePasswordState();
}

class _updatePasswordState extends State<updatePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(child: Center(
          child: Column(children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  HeaderWidget("Login", text: 'Forget Your Password',),
                  SizedBox(height: 30,),
                  _buildTextFormField(
                    controller: _passwordController,
                    hintText: "Password",
                    icon: Icons.password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40,),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Call the signUp method from SignUpService
                        ForgetPasswordService.UpdatePassword(
                          widget.email,
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
                          "Send",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],),
              ),)]),)),
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
