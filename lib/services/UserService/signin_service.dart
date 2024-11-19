import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/User/Home.dart';
import '../../utils/api_constants.dart';

class SignInService {
  static String? _token; // Store token here
  static int? _userId; // Store user ID here

  static Future<void> login(String phone, String password, BuildContext context) async {
    final String apiUrl = ApiConstants.loginCustomer; // Use the API constant

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
        _token = responseData['token']; // Store the token
        Map<String, dynamic> decodedToken = JwtDecoder.decode(_token!);
        _userId = decodedToken['id']; // Store user ID

        // Save token and user ID in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!); // Save the token
        await prefs.setInt('userId', _userId!); // Save the user ID

        print('Login successful: ${decodedToken}');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(id: _userId!)));
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse['message'] ?? 'Login failed';
        print('Login failed: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred. Please try again later.')));
    }
  }

  // Method to retrieve the token and user ID
  static String? get token => _token;
  static int? get userId => _userId; // Added getter for user ID
}
