import 'package:Foodu/services/signin_service.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/api_constants.dart';
class UpdateUser {
  Future<void> updateUser(int userId, Map<String, dynamic> updateData) async {
    final String apiUrl = ApiConstants.updateCustomer;
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
