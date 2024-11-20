import 'package:Foodu/models/Card.model.dart';
import 'package:Foodu/widgets/CartWidget/EmptyCart.dart';
import 'package:Foodu/widgets/CartWidget/LocationBarWidget.dart';
import 'package:Foodu/widgets/CartWidget/ProductItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../utils/api_constants.dart';
import '../utils/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/CartWidget/OrderSummaryWidget.dart';

class Cardscreen extends StatefulWidget {
  const Cardscreen({super.key, required this.userId});
  final int userId;

  @override
  State<Cardscreen> createState() => _CardscreenState();
}

class _CardscreenState extends State<Cardscreen> {
  bool _isCreatingOrder = false; // Initially set to false
  String userLocation = '';
  void initState() {
    super.initState();
    getCurrentLocationApp();
  }

  Future<void> getCurrentLocationApp() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return;
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLocation = "${position.latitude}, ${position.longitude}";
    });
  }


  double calculateSubtotal(CartProvider cart) {
    double subtotal = 0;
    for (var product in cart.products) {
      final double price = double.tryParse(
          product.product['price']?.toString() ?? '0') ?? 0;
      final quantity = product.quantity ?? 1;
      subtotal += price * quantity;
    }
    return subtotal;
  }

  Future<void> makeOrder() async {
    setState(() {
      _isCreatingOrder = true; // Start loading
    });

    try {
      final cart = Provider.of<CartProvider>(context, listen: false);
      double subtotal = calculateSubtotal(cart);
      double deliveryFee = 2;
      double totalPrice = subtotal + deliveryFee;

      List<Map<String, dynamic>> orderItems = cart.products.map((product) {
        return {
          "quantity": product.quantity,
          "productId": product.product['id'],
        };
      }).toList();

      Map<String, dynamic> orderData = {
        "totalPrice": totalPrice,
        "location": userLocation,
        "status": "Padding",
        "customerId": widget.userId,
        "orderItems": orderItems,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.createOrder),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Order added to cart successfully!",
              style: TextStyle(fontSize: 16, fontFamily: "Urbanist-Bold"),
            ),
            backgroundColor: Colors.indigo,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to create order. Please try again.",
              style: TextStyle(fontSize: 16, fontFamily: "Urbanist-Bold"),
            ),
            backgroundColor: errorColor,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "An error occurred. Please try again.",
            style: TextStyle(fontSize: 16, fontFamily: "Urbanist-Bold"),
          ),
          backgroundColor: errorColor,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isCreatingOrder = false; // Stop loading once the process is done
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Cart',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Urbanist-Bold',
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.products.isEmpty) {
            return EmptyCart();
          }

          final subtotal = calculateSubtotal(cart);
          final deliveryFee = 2.0;
          final total = subtotal + deliveryFee;

          return CustomScrollView(
            slivers: [
              // Location Bar
              SliverToBoxAdapter(
                child: LocationBarWidget(),
              ),

              // Product List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = cart.products[index];
                    return ProductItemWidget(product: product, cart: cart, successColor: successColor);
                  },
                  childCount: cart.products.length,
                ),
              ),

              // Summary
              SliverFillRemaining(
                hasScrollBody: false,
                child:OrderSummary(
                  subtotal: subtotal,
                  deliveryFee: deliveryFee,
                  total: total,
                  isCreatingOrder: _isCreatingOrder,
                  makeOrder: makeOrder,
                  successColor: successColor,
                ),

              ),
            ],
          );
        },
      ),
    );
  }
}