import 'dart:convert';
import 'package:Foodu/auth/Userauth/SignInForm.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../utils/api_constants.dart';

class SignUpService {
  static Future<void> signUp(String name, String email, String phone, String password, BuildContext context) async {
    final String apiUrl = ApiConstants.registerCustomer;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Sign Up successful: ${responseData['message']}');

        // Navigate to the login page on success
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignInForm()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign Up successful")),
        );

      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse['message'] ?? 'Sign up failed';
        print('Sign Up failed: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error during sign-up: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }
}
