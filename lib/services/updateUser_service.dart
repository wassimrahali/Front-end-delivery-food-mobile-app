import 'package:Foodu/services/signin_service.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/signin_service.dart';
class UpdateUser {
  Future<void> updateUser(int userId, Map<String, dynamic> updateData) async {
    final String apiUrl = "http://192.168.1.2:8000/api/auth/customer/$userId";
    final url = Uri.parse(apiUrl); // Corrected here

    String? token = SignInService.token; // Get the stored token
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include the token in the headers
      },
      body: json.encode(updateData),
    );

    if (response.statusCode == 200) {
      print('Updated successfully');
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }
}
