import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../products/productsDetails.dart';

class DiscountCard extends StatelessWidget {
  final Map<String, dynamic> product; // Declare product variable

  const DiscountCard({super.key, required this.product}); // Constructor

  @override
  Widget build(BuildContext context) {
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
                        product['description'] ?? 'No description available',
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

Widget _buildDiscountSection(BuildContext context, List<Map<String, dynamic>> products) {
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
            style: TextStyle(fontSize: 18, fontFamily: "Urbanist-Bold"),
          ),
          TextButton(
            onPressed: () {
              // Implement 'See All' button functionality
            },
            child: const Text(
              'See All',
              style: TextStyle(color: Colors.green, fontFamily: "Urbanist-Bold"), // Assuming successColor is green
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: DiscountCard(product: products[0]),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DiscountCard(
              product: products.length > 1 ? products[1] : products[0],
            ),
          ),
        ],
      ),
    ],
  );
}
