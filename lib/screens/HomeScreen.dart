import 'dart:convert';
import 'package:Foodu/services/home_service_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:Foodu/products/productsDetails.dart';
import 'package:Foodu/utils/colors.dart';

class Homescreen extends StatefulWidget {
  final int userId;
  const Homescreen({super.key, required this.userId});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String userName = '';
  bool isLoading = true;
  List<dynamic> categories = [];
  List<dynamic> products = [];

  Future<void> loadAllData() async {
    try {
      // Load user data
      final response = await get(Uri.parse("http://192.168.1.2:8000/api/auth/customer/${widget.userId}"));
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        // Load categories and products simultaneously
        final categoriesData = await GetHome().GetData();
        final productsData = await GetHome().GetProductData();

        setState(() {
          userName = userData['name'];
          categories = categoriesData;
          products = productsData;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error appropriately
      print('Error loading data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.green,  // Change to any color you want
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildSpecialOffers(),
            const SizedBox(height: 20),
            _buildCategories(),
            const SizedBox(height: 20),
            _buildDiscountSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("deliver to",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Row(
                  children: [
                    Text(userName,
                        style: TextStyle(fontFamily: "Urbanist-Bold")),
                    Icon(Icons.keyboard_arrow_down,
                        color: Colors.green, size: 16),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {}
            ),
            IconButton(
                icon: Icon(Icons.shopping_bag_outlined),
                onPressed: () {}
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'What are you craving?',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildSpecialOffers() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/food.png',
              height: 120,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Text(
                  "30% \n discount only \n valid for today!",
                  style: TextStyle(
                      fontFamily: "Lucky-font",
                      fontSize: 20,
                      color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    if (categories.isEmpty) {
      return Center(child: Text('No categories available'));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Categories',
                style: TextStyle(fontSize: 18, fontFamily: "Urbanist-Bold")),
            TextButton(
              onPressed: () {},
              child: Text('See All',
                  style: TextStyle(color: successColor, fontFamily: "Urbanist-Bold")),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.1),
                  radius: 30,
                  child: Image.network(
                    category['image'],
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  category['name'],
                  style: TextStyle(fontSize: 12),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDiscountSection() {
    if (products.isEmpty) {
      return Center(child: Text('No products available'));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Discount Guaranteed! 👌',
                style: TextStyle(fontSize: 18, fontFamily: "Urbanist-Bold")),
            TextButton(
              onPressed: () {},
              child: Text('See All',
                  style: TextStyle(color: successColor, fontFamily: "Urbanist-Bold")),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildDiscountCard(context, products[0]),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDiscountCard(context, products.length > 1 ? products[1] : products[0]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscountCard(BuildContext context, Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Productsdetails(product: product)),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'PROMO',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? 'Product Name',
                        style: TextStyle(
                          fontFamily: "Urbanist-Bold",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        product['description'] ?? 'No description available',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}