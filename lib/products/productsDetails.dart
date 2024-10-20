import 'package:flutter/material.dart';
import '../utils/colors.dart'; // Ensure you have color definitions in this file

class Productsdetails extends StatefulWidget {
  final Map<String, dynamic> product;
  final String categoryName; // Add this line to hold the category name

  const Productsdetails({
    Key? key,
    required this.product,
    required this.categoryName, // Add this line to the constructor
  }) : super(key: key);

  @override
  State<Productsdetails> createState() => _ProductsdetailsState();
}

class _ProductsdetailsState extends State<Productsdetails> {
  String _selectedSize = '10"'; // Initial selected size
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final double price = double.tryParse(product['price']?.toString() ?? '0') ?? 0; // Get the product price as a double
    final double totalPrice = price * quantity; // Calculate total price

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          product['name'] ?? 'Product Details',
          style: TextStyle(fontSize: 20, fontFamily: 'Urbanist-Bold', color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black), // Back button color
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  product['mainImage'] ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  child: Text(
                    // Hello you can acccess to category with widget ande with map
                    product['category'] != null ? product['category']['name'] : widget.categoryName,
                    style: TextStyle(
                      fontFamily: "Urbanist-Regular",
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  product['name'] ?? 'Product Name',
                  style: TextStyle(
                    fontFamily: 'Urbanist-Bold',
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  product['description'] ?? 'No description available',
                  style: TextStyle(
                    fontFamily: 'Urbanist-Regular',
                    fontSize: 17,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconText('assets/images/Motos.png', '20min'),
                  _buildIconText('assets/images/Star 1.png', '4.5'),
                  _buildIconText('assets/images/Clock.png', '5pm'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      "Size: ",
                      style: TextStyle(
                        fontFamily: "Urbanist-Regular",
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  _buildSizeButton('10"'),
                  SizedBox(width: 10),
                  _buildSizeButton('12"'),
                  SizedBox(width: 10),
                  _buildSizeButton('14"'),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: grise,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${totalPrice.toStringAsFixed(3)} DT',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Urbanist-SemiBold',
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: grayScale,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline_outlined, color: Colors.grey),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                ),
                                Text(
                                  '$quantity',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add_circle, color: Colors.grey[200]),
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          // Add to cart functionality
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Container(
                            constraints: BoxConstraints(minWidth: double.infinity, minHeight: 56),
                            alignment: Alignment.center,
                            child: Text(
                              "ADD TO CART",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "Urbanist-Bold"
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(String assetPath, String text) {
    return Row(
      children: [
        Image.asset(assetPath, width: 20),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(fontFamily: "Urbanist-Bold"),
        ),
      ],
    );
  }

  Widget _buildSizeButton(String size) {
    bool isSelected = _selectedSize == size;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: isSelected ? successColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          size,
          style: TextStyle(
            fontFamily: "Urbanist-SemiBold",
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
