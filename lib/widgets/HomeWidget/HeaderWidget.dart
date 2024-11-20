import 'package:Foodu/Cartscreen/Cartscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Foodu/auth/Userauth/SignInForm.dart';
import '../../utils/api_constants.dart';
import '../../utils/colors.dart';

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
  bool _isLoading = false;

  Future<void> logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String apiUrl = ApiConstants.LogoutCustomer;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        _showSnackBar('No active session found!');
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
        Get.offAll(SignInForm());
        _showSnackBar('Successfully logged out');
      } else {
        _showSnackBar('Logout failed! Please try again.');
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
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
              onPressed: _isLoading ? null : () {},
              splashRadius: 24,
            ),
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined),
              onPressed: _isLoading
                  ? null
                  : () => Get.to(Cardscreen(userId: widget.userId)),
              splashRadius: 24,
            ),
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(successColor),
                  ),
                )
                    : const Icon(Icons.logout),
              ),
              onPressed: _isLoading ? null : logout,
              splashRadius: 24,
            ),
          ],
        ),
      ],
    );
  }
}