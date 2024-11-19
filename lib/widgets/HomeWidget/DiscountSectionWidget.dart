import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http for making network requests
import 'dart:convert'; // Import for jsonDecode
import '../../products/productsDetails.dart';
import '../../utils/api_constants.dart';
import '../../utils/colors.dart'; // Ensure this color file has the defined colors

class DiscountSectionWidget extends StatefulWidget {
  const DiscountSectionWidget({super.key});

  @override
  State<DiscountSectionWidget> createState() => _DiscountSectionWidgetState();
}

class _DiscountSectionWidgetState extends State<DiscountSectionWidget> {
  // Added products list declaration
  final List<Map<String, dynamic>> products = [];
  // Initialize this with your data

  @override
  void initState() {
    super.initState();
    _fetchProductData(); // Fetch products when the widget initializes
  }

  // Fetch Products Data
  Future<void> _fetchProductData() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.getAllProducts));

      if (response.statusCode == 200) {
        // Update the state with the fetched product data
        setState(() {
          products.addAll(List<Map<String, dynamic>>.from(jsonDecode(response.body)));
        });
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (error) {
      // Handle errors appropriately
      print(error); // You can replace this with a proper error message in your UI
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if products list is empty
    if (products.isEmpty) {
      return const Center(child: Text('No products available'));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Discount Guaranteed! 👌',
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Urbanist-Bold",
              ),
            ),
            TextButton(
              onPressed: () {
                // Define action for "See All"
              },
              child: Text(
                'See All',
                style: TextStyle(
                  color: successColor, // Make sure successColor is defined in your colors
                  fontFamily: "Urbanist-Bold",
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Grid view to display all products
        GridView.builder(
          shrinkWrap: true, // Prevents the GridView from taking infinite height
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two cards per row
            childAspectRatio: 0.7, // Adjust the aspect ratio for the cards
            crossAxisSpacing: 10, // Space between cards in the horizontal direction
            mainAxisSpacing: 10, // Space between cards in the vertical direction
          ),
          itemCount: products.length, // Number of products
          itemBuilder: (context, index) {
            return _buildDiscountCard(context, products[index]);
          },
        ),
      ],
    );
  }

  Widget _buildDiscountCard(BuildContext context, Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Productsdetails(product: product, categoryName: '', quantity: null,),
          ),
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
              // Display the product image
              Image.network(
                product['mainImage'],
                fit: BoxFit.cover,
                height: double.infinity, // Set the height of the image
                width: double.infinity, // Set width to fill the container
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'PROMO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? 'Product Name',
                        style: const TextStyle(
                          fontFamily: "Urbanist-Bold",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product['category'] != null ? product['category']['name'] : 'No description available' ,
                        style: const TextStyle(
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