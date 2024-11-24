import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/api_constants.dart';

class UpdateUser {
  Future<void> updateUser(String userId, Map<String, dynamic> updateData) async {
    final String apiUrl = '${ApiConstants.updateCustomer}$userId';
    final url = Uri.parse(apiUrl);

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(updateData),
    );

    if (response.statusCode == 200) {
      print('Customer updated successfully.');
    } else {
      throw Exception('Failed to update customer: ${response.body}');
    }
  }

  Future<void> updateDeliveryMan(String userId, Map<String, dynamic> updatedData) async {
    final url = Uri.parse(ApiConstants.updateDeliveryMan+userId);
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update deliveryman: ${response.body}');
    }
  }}
