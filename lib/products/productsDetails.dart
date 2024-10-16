import 'package:flutter/material.dart';

import '../utils/colors.dart';

class Productsdetails extends StatefulWidget {
  final Map<String, dynamic> product;

  const Productsdetails({Key? key, required this.product}) : super(key: key);

  @override
  State<Productsdetails> createState() => _ProductsdetailsState();
}

class _ProductsdetailsState extends State<Productsdetails> {
  String _selectedSize = '10"'; // Initial selected size
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Image.network(product['image_url'] ?? 'https://via.placeholder.com/150'), // Product image
              Padding(
                padding: const EdgeInsets.only(right: 18, left: 18),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  child: Text(
                    product['category'] ?? 'Category', // Category
                    style: TextStyle(
                      fontFamily: "Urbanist-Regular",
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 18, left: 18),
                child: Text(
                  product['name'] ?? 'Product Name', // Product name
                  style: TextStyle(
                    fontFamily: 'Urbanist-Bold',
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  product['description'] ?? 'No description available', // Product description
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
                            '\$${product['price'] ?? '0'}',
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Urbanist-Regular',
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
          )
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
