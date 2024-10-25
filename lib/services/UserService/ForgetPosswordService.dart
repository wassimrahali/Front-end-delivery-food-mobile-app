import 'dart:convert';

import 'package:Foodu/auth/Userauth/SignInForm.dart';
import 'package:Foodu/auth/Userauth/VerifyResetCodePage.dart';
import 'package:Foodu/auth/Userauth/updatePassword.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../utils/api_constants.dart';

class ForgetPasswordService {
  static Future<void> sendEmail(String email, BuildContext context) async {
    final String apiUrl = ApiConstants.sendEmail;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        print('Email sent successfully: ${response.body}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Check your email for further instructions.")),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyResetCodePage(email:email)));
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse['message'] ?? 'Failed to send email';
        print('Failed to send email: $errorMessage (status: ${response.statusCode})');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error during sending email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  static Future<void> validPassword(String email, String code, BuildContext context) async {
    final String apiUrl = ApiConstants.resetPassword;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email, 'code': code}),
      );

      if (response.statusCode == 200) {
        print('Code validated successfully: ${response.body}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Code validated successfully. Please reset your password.")),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => updatePassword(email:email)));
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse['error'] ?? 'Failed to validate code';
        print('Failed to validate code: $errorMessage (status: ${response.statusCode})');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error during code validation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }
  static Future<void> UpdatePassword(String email, String password, BuildContext context) async {
    final String apiUrl = ApiConstants.updatePasswordByEmail;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email, 'newPassword': password}),
      );

      if (response.statusCode == 200) {
        print('Password updated successfully: ${response.body}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated successfully.")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInForm()),
        );
      } else {
        print('Failed with email: $email');
        // Print the response to debug
        print('Response: ${response.body}');

        // Extracting error message from the response
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse['error'] ?? 'Failed to update password';

        print('Failed to update password: $errorMessage (status: ${response.statusCode})');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error during password update: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  }

