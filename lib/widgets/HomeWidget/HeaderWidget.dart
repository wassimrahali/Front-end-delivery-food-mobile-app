import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Foodu/auth/Userauth/SignInForm.dart';
import '../../utils/api_constants.dart';

class HeaderWidget extends StatefulWidget {
  final String userName;
  final int userId;

  const HeaderWidget({
    super.key,
    required this.userName,
    required this.userId,
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  bool _isLoading = false; // Flag to manage loading state

  Future<void> logout() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final String apiUrl = ApiConstants.LogoutCustomer;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No active session found!')),
        );
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');

        Get.offAll(SignInForm()); // Redirect to the sign-in page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully logged out')),
        );
      } else {
        // Handle error if logout fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed! Please try again.')),
        );
      }
    } catch (e) {
      // Handle any other errors (network, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator once done
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/images/avatar.png'),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Deliver to",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Row(
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(fontFamily: "Urbanist-Bold"),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.green,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _isLoading ? null : logout, // Disable logout button while loading
            ),
          ],
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(), // Show loading indicator
          ),
      ],
    );
  }
}
