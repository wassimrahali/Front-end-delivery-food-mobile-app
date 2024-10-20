import 'package:flutter/material.dart';
import '../utils/colors.dart'; // Ensure you have color definitions in this file

class Productsdetails extends StatefulWidget {
  final Map<String, dynamic> product;
  final String categoryName; // Hold the category name

  const Productsdetails({
    Key? key,
    required this.product,
    required this.categoryName, // Add this line to the constructor
  }) : super(key: key);

  @override
  State<Productsdetails> createState() => _ProductsdetailsState();
}

class _ProductsdetailsState extends State<Productsdetails> {
  late String _selectedSize; // Declare the selected size
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedSize with the first size in the product['sizes'] if available
    if (widget.product['sizes'] != null && widget.product['sizes'].isNotEmpty) {
      _selectedSize = widget.product['sizes'][0]; // Set to the first size
    } else {
      _selectedSize = '10"'; // Fallback to a default size if no sizes are available
    }
  }
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final double price = double.tryParse(product['price']?.toString() ?? '0') ?? 0; // Get the product price as a double
    final double totalPrice = price * quantity; // Calculate total price

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product['name'] ?? 'Product Details',
          style: TextStyle(fontSize: 20, fontFamily: 'Urbanist-Bold', color: Colors.black),
        ),
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
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    product['category'] != null ? product['category']['name'] : widget.categoryName,
                    style: TextStyle(
                      fontFamily: "Urbanist-Regular",
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
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
                  _buildIconText('assets/images/Motos.png', product['preparationDuration'] ?? '20min'),
                  _buildIconText('assets/images/Star 1.png', product['rating'] ?? '4.5'), // Use the product rating
                  _buildIconText('assets/images/Clock.png', '5pm'), // Update this if needed

                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Size: ",
                      style: TextStyle(
                          fontFamily: 'Urbanist-Bold',
                          fontSize: 20,
                      ),
                    ),
                    ...product['sizes'].map<Widget>((size) => _buildSizeButton(size)).toList(),
                  ],
                ),
              ),
              SizedBox(height: 10),
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
                              color: successColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove, color: Colors.white),
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
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Urbanist-Bold"),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.grey[200]),
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
        alignment: Alignment.center,
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: isSelected ? successColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
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
