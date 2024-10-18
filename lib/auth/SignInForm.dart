import 'package:Foodu/services/signin_service.dart';
import 'package:flutter/material.dart';
import '../widgets/HeaderWidget.dart';
import '../widgets/PasswordFieldWidget.dart';
import '../widgets/SignInButtonWidget.dart';
import '../widgets/SignUpOptionWidget.dart';
import '../widgets/SocialMediaIconsWidget.dart';

import '../widgets/TextDivderWidget.dart';
import '../widgets/phoneFieldWidget.dart';

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
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              HeaderWidget("Login ", text: 'Login To Your Account',),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      PhoneFieldWidget(onChanged: (value) => phone = value),
                      SizedBox(height: 20),
                      PasswordFieldWidget(onChanged: (value) => password = value),
                      SizedBox(height: 40),
                      SignInButtonWidget(text: 'Sign In',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await SignInService.login(phone!, password!, context);
                          }
                        },
                      ),
                      SizedBox(height: 30),
                      TextDividerWidget(text: "Or continue with"),
                      SizedBox(height: 30),
                      SocialMediaIconsWidget(),
                      SizedBox(height: 40),
                      SignUpOptionWidget(),
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




