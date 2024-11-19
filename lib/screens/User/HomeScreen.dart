import 'dart:convert';
import 'package:Foodu/widgets/HomeWidget/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Foodu/widgets/HomeWidget/DiscountSectionWidget.dart';
import 'package:Foodu/widgets/HomeWidget/CategoryWidget.dart';
import 'package:Foodu/widgets/HomeWidget/SearchBarWidget.dart';
import 'package:Foodu/widgets/HomeWidget/SpeacialOffersWidget.dart';
import '../../utils/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  final int userId;

  const Homescreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
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
      throw Exception('Failed to fetch categories: ${response.reasonPhrase}');
    }
  }

  // Fetch Products Data
  Future<List<dynamic>> getProductData() async {
    final response = await http.get(Uri.parse(ApiConstants.getAllProducts));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch products: ${response.reasonPhrase}');
    }
  }

  // Fetch User Data using Token
  Future<void> loadAllData() async {
    try {
      // Get token from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Adjust key based on your implementation

      if (token != null) {
        // Fetch user data using token
        final response = await http.get(
          Uri.parse(ApiConstants.getCustomerById + widget.userId.toString()), // Use widget.userId
          headers: {
            'Authorization': 'Bearer $token',
          },
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
              products = futures[1];
              isLoading = false;
            });
          }


        } else {
          throw Exception('Failed to fetch user data: ${response.reasonPhrase}');
        }
      } else {
        // Handle case where token is null (user not signed in)
        setState(() {
          isLoading = false;
        });
        // Optionally, navigate to the sign-in screen
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
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            HeaderWidget(userName: userName, userId: widget.userId,),
            const SizedBox(height: 20),
            SearchbarWidget(),
            const SizedBox(height: 20),
            SpeacialOffersWidget(),
            const SizedBox(height: 20),
            CategoryWidget(categories: categories),
            const SizedBox(height: 20),
            DiscountSectionWidget(),
          ],
        ),
      ),
    );
  }
}
