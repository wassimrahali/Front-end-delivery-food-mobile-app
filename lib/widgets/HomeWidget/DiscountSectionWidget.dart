import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../products/productsDetails.dart';
import '../../utils/colors.dart'; // Added missing material import

class DiscountSectionWidget extends StatefulWidget {
  const DiscountSectionWidget({super.key});

  @override
  State<DiscountSectionWidget> createState() => _DiscountSectionWidgetState();
}

class _DiscountSectionWidgetState extends State<DiscountSectionWidget> {
  // Added products list declaration
  final List<Map<String, dynamic>> products = []; // You should initialize this with your data

  @override
  Widget build(BuildContext context) { // Added BuildContext context parameter
    if (products.isEmpty) {
      return const Center(child: Text('No products available')); // Added const
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text( // Added const
              'Discount Guaranteed! 👌',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Urbanist-Bold"
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(
                    color: successColor, // You need to define successColor or use a direct color
                    fontFamily: "Urbanist-Bold"
                ),
              ),
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
              child: _buildDiscountCard(
                  context,
                  products.length > 1 ? products[1] : products[0]
              ),
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
          MaterialPageRoute(
            builder: (context) => Productsdetails(product: product), // Make sure Productsdetails is imported
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
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Added const
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text( // Added const
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
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Added const
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
                        style: const TextStyle( // Added const
                          fontFamily: "Urbanist-Bold",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4), // Added const
                      Text(
                        product['description'] ?? 'No description available',
                        style: const TextStyle( // Added const
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