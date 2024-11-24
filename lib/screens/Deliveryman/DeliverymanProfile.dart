import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_constants.dart';
import '../../utils/colors.dart';
import '../../widgets/AuthFormWidget/SignInButtonWidget.dart';

class DeliverymanProfile extends StatefulWidget {
  final int userId;

  const DeliverymanProfile({Key? key, required this.userId}) : super(key: key);

  @override
  _DeliverymanProfileState createState() => _DeliverymanProfileState();
}

class _DeliverymanProfileState extends State<DeliverymanProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final userData = await _fetchUserById();
      _nameController.text = userData['name'] ?? '';
      _phoneController.text = userData['phone'] ?? '';
    } catch (e) {
      _showSnackBar('Error loading user data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>> _fetchUserById() async {
    final url = Uri.parse('${ApiConstants.getDeliveryManById}${widget.userId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch user data: ${response.body}');
    }
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedData = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      if (_passwordController.text.isNotEmpty)
        'password': _passwordController.text.trim(),
    };

    try {
      setState(() => _isLoading = true);
      await _updateDeliveryMan(widget.userId, updatedData);
      _showSnackBar('Profile updated successfully!');
    } catch (e) {
      _showSnackBar('Failed to update profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateDeliveryMan(int userId, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('${ApiConstants.updateDeliveryMan}$userId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update deliveryman: ${response.body}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Edit Your Profile",
          style: TextStyle(fontFamily: 'Urbanist-Bold', fontSize: 20),
        ),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(color: successColor),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Image.asset("assets/images/profile.png"),
              ),
              const SizedBox(height: 30),
              _buildTextField(
                controller: _nameController,
                label: "Name",
                icon: Icons.drive_file_rename_outline_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              _buildTextField(
                controller: _phoneController,
                label: "Phone",
                icon: Icons.phone_android_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              _buildTextField(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              SignInButtonWidget(
                onPressed: _updateUser,
                text: 'Update Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: successColor),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
