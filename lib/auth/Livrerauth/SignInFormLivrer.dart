import 'package:Foodu/services/Livrerservice/signin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../widgets/AuthFormWidget/HeaderWidget.dart';
import '../../widgets/AuthFormWidget/PasswordFieldWidget.dart';
import '../../widgets/AuthFormWidget/SignInButtonWidget.dart';
import '../../widgets/AuthFormWidget/SignUpOptionWidget.dart';
import '../../widgets/AuthFormWidget/SocialMediaIconsWidget.dart';

import '../../widgets/AuthFormWidget/TextDivderWidget.dart';
import '../../widgets/AuthFormWidget/phoneFieldWidget.dart';

class SignInFormLivrer extends StatefulWidget {
  const SignInFormLivrer({super.key});

  @override
  State<SignInFormLivrer> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInFormLivrer> {
  final _formKey = GlobalKey<FormState>();
  String? phone;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Center(child: Image.asset("assets/images/3d.png")),

              SizedBox(height: 10),
              Center(child:
              //SizedBox(width: 15),
              ClipRRect(
                child: Image.asset("assets/images/Group.png"),
              ),

              ),

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
                      // TextDividerWidget(text: "Or continue with"),
                      // SizedBox(height: 30),
                      // SocialMediaIconsWidget(),
                      // SizedBox(height: 40),
                      // SignUpOptionWidget(),
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

