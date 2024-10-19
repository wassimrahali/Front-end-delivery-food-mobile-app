import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Foodu/products/productsDetails.dart';
import 'package:Foodu/utils/colors.dart';
import '../utils/api_constants.dart';

class GetHome extends StatefulWidget {
  final String userId; // Added userId parameter

  const GetHome({
    super.key,
    required this.userId,
  });

  @override
  State<GetHome> createState() => _GetHomeState();
}

class _GetHomeState extends State<GetHome> {
  String userName = '';
  bool isLoading = true;
  List<dynamic> categories = [];
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  // Fetch Categories Data
  Future<List<dynamic>> getCategoriesData() async {
    final response = await http.get(Uri.parse(ApiConstants.getAllCategories));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  // Fetch Products Data
  Future<List<dynamic>> getProductData() async {
    final response = await http.get(Uri.parse(ApiConstants.getAllProducts));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<void> loadAllData() async {
    try {
      // Load user data
      final response = await http.get(
        Uri.parse('${ApiConstants.getCustomerById}${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        // Load categories and products simultaneously
        final futures = await Future.wait([
          getCategoriesData(),
          getProductData(),
        ]);

        if (mounted) {
          setState(() {
            userName = userData['name'];
            categories = futures[0];
            products = futures[0];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      debugPrint('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Return your actual widget tree here
    return Container(); // Replace with your actual UI
  }
}