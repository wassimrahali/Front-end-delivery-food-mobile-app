import 'package:Foodu/widgets/AuthFormWidget/ForgetPasswordWidget.dart';
import 'package:flutter/material.dart';
import 'package:Foodu/services/UserService/signin_service.dart';
import '../../widgets/AuthFormWidget/HeaderWidget.dart';
import '../../widgets/AuthFormWidget/PasswordFieldWidget.dart';
import '../../widgets/AuthFormWidget/SignInButtonWidget.dart';
import '../../widgets/AuthFormWidget/SignUpOptionWidget.dart';
import '../../widgets/AuthFormWidget/SocialMediaIconsWidget.dart';
import '../../widgets/AuthFormWidget/TextDivderWidget.dart';
import '../../widgets/AuthFormWidget/phoneFieldWidget.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

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
                      SignInButtonWidget(
                        text: 'Sign In',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await SignInService.login(phone!, password!, context);
                          }
                        },
                      ),
                      SizedBox(height: 30),
                      TextDividerWidget(text: "Or continue with",textStyle:TextStyle(color: Colors.black),color: Colors.black45),
                      SizedBox(height: 30),
                      SocialMediaIconsWidget(),
                      SizedBox(height: 40),
                      SignUpOptionWidget(),
                      SizedBox(height: 20),
                      Forgetpasswordwidget()
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
