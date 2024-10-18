import 'package:Foodu/utils/colors.dart';
import 'package:Foodu/widgets/SignInButtonWidget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../services/signin_service.dart';
import '../services/updateUser_service.dart';

class UpdateUserScreen extends StatefulWidget {
  final int userId;

  const UpdateUserScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final UpdateUser _userService = UpdateUser();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = true;
  late final int Id;
  String userName = '';

  // Regular expressions for validation
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
  final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await GetuserId();
      setState(() {
        userName = userData['name'];
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e'))
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> GetuserId() async {
    final response = await get(
        Uri.parse("http://192.168.1.2:8000/api/auth/customer/${widget.userId}")
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      setState(() {
        userName = userData['name'];
      });
      return userData;
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  void _updateUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in'))
      );
      return;
    }

    Map<String, dynamic> updatedData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      if (_passwordController.text.isNotEmpty)
        'password': _passwordController.text,
    };

    try {
      setState(() => _isLoading = true);
      await _userService.updateUser(widget.userId, updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User updated successfully!'))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user: $e'))
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
          title: Text(
            "Fill Your Profile",
            style: TextStyle(fontFamily: 'Urbanist-Bold', fontSize: 20),
          )
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(
        color: successColor,
      ))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(child: Image.asset("assets/images/profile.png")),
                SizedBox(height: 30),
                Text(
                    userName.isNotEmpty ? userName : 'Loading...',
                    style: TextStyle(fontFamily: "Urbanist-Bold", fontSize: 22)
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: userName,
                    labelText: "Name",
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Urbanist-Regular',
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.drive_file_rename_outline_outlined, color: successColor),
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                    labelText: "Email Address",
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Urbanist-Regular',
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.email_outlined, color: successColor),
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                TextFormField(
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    labelText: "Phone",
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Urbanist-Regular',
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.phone_android_rounded, color: successColor),
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!passwordRegex.hasMatch(value)) {
                        return 'Password must be at least 8 characters with letters and numbers';
                      }
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter new password",
                    labelText: "Password (optional)",
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Urbanist-Regular',
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.password, color: successColor),
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  obscureText: true,
                ),

                SizedBox(height: 40),
                SignInButtonWidget(onPressed: _updateUser, text: "Update")
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}