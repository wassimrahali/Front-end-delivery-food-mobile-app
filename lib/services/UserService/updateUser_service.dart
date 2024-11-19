import 'package:Foodu/services/UserService/signin_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/api_constants.dart';

class UpdateUser {
  Future<void> updateUser(String userId, Map<String, dynamic> updateData) async {
    final String apiUrl = '${ApiConstants.updateCustomer+'$userId'}';
    final url = Uri.parse(apiUrl);

    String? token = SignInService.token;
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
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
