import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../screens/Home.dart';

class SignInService {
  static Future<void> login(String phone, String password, BuildContext context) async {
    final String apiUrl = 'http://192.168.1.2:8000/api/auth/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Login successful: ${responseData}');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse['message'] ?? 'Login failed';
        print('Login failed: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }


}