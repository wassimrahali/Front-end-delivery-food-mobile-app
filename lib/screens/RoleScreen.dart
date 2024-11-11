import 'package:Foodu/auth/Livrerauth/SignInFormLivrer.dart';
import 'package:Foodu/auth/Userauth/SignInForm.dart';
import 'package:Foodu/utils/colors.dart';
import 'package:Foodu/widgets/AuthFormWidget/SignInButtonWidget.dart';
import 'package:flutter/material.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  String _selectedRole = 'Customer'; // Default selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Center(child: Image.asset("assets/images/one.png")),
              Center(
                  child: Center(
                    child: Text(
                      "Together, we make your life better.",
                      style: TextStyle(fontSize: 20, fontFamily: 'Urbanist-Bold'),
                    ),
                  ),
                ),
              SizedBox(height: 20,),
              Card(
                elevation: 0.0, // Removes elevation/shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.green[50], // Light green background for the card
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: const Text(
                          'Customer',
                          style: TextStyle(fontFamily: 'Urbanist-Bold'),
                        ),
                        trailing: Radio<String>(
                          value: 'Customer',
                          groupValue: _selectedRole,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                          activeColor: successColor, // Green active radio button
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10), // Space between cards
              Card(
                elevation: 0.0, // Removes elevation/shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.green[50], // Light green background for the card
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: const Text(
                          'Delivery Man',
                          style: TextStyle(fontFamily: 'Urbanist-Bold'),
                        ),
                        trailing: Radio<String>(
                          value: 'Delivery Man',
                          groupValue: _selectedRole,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                          activeColor: successColor, // Green active radio button
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SignInButtonWidget(
            onPressed: () {
              if (_selectedRole == 'Customer') {
                // Navigate to the sign-in screen for the customer role
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SignInForm(),)); // Update with your actual route
              } else if (_selectedRole == 'Delivery Man') {
                // Handle navigation for Delivery Man if needed
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SignInFormLivrer(),)); // Update with your actual route
              }
            },
            text: "Submit",
          )
        ],
      ),
    );
  }
}
