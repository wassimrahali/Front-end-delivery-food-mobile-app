import 'package:Foodu/services/livrerservice/signin_service.dart';
import 'package:flutter/material.dart';
import '../../../widgets/HeaderWidget.dart';
import '../../../widgets/PasswordFieldWidget.dart';
import '../../../widgets/SignInButtonWidget.dart';
import '../../../widgets/SignUpOptionWidget.dart';
import '../../../widgets/SocialMediaIconsWidget.dart';

import '../../../widgets/TextDivderWidget.dart';
import '../../../widgets/phoneFieldWidget.dart';

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
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [

                  ClipRRect(
                    child: Image.asset("assets/images/logo1.png"),
                  ),SizedBox(width: 20),
                  Text("Foodu",style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Urbanist-SemiBold",
                    fontSize: 40,
                  ),)
                ],
              ),
            SizedBox(height: 20),
              Center(
                child: Container(child: Row(
                  children: [
                    SizedBox(width: 20),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        "      Welcome Back, Deliverer!\n       Sign in to your account ",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Urbanist-SemiBold"
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                  ],
                ),
                ),
              ),
              SizedBox(height: 20),


              CircleAvatar(
                backgroundColor: Colors.green.withOpacity(0.1),
                radius: 30,
                child: Image.asset(
                  "assets/images/livraison-rapide.png",
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),



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




