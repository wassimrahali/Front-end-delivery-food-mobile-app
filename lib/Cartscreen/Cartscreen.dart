import 'package:Foodu/models/Card.model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/api_constants.dart';
import '../utils/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cardscreen extends StatefulWidget {
  const Cardscreen({super.key, required this.userId});
  final int userId;

  @override
  State<Cardscreen> createState() => _CardscreenState();
}

class _CardscreenState extends State<Cardscreen> {
  String userLocation = ''; // Variable to hold user location

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
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userLocation = "${position.latitude}, ${position.longitude}";
    print("Current location: $userLocation");
  }

  double calculateSubtotal(CartProvider cart) {
    double subtotal = 0;
    for (var product in cart.products) {
      final double price = double.tryParse(product.product['price']?.toString() ?? '0') ?? 0;
      final quantity = product.quantity ?? 1;
      subtotal += price * quantity;
    }
    return subtotal;
  }

  Future<void> makeOrder() async {
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
      "status": "NOT_VALIDATED",
      "deliveryManId": 2,
      "customerId": widget.userId,
      "orderItems": orderItems,
    };
    print("Order Data: ${jsonEncode(orderData)}");

    // Make POST request
    final response = await http.post(
      Uri.parse(ApiConstants.createOrder),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 201) {
      print("Order created successfully.");
    } else {
      print("Failed to create order: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocationApp(); // Fetch the location when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Consumer<CartProvider>(
          builder: (context, cart, child) {
            return Text(
              'Cart',
              style: TextStyle(fontSize: 20, fontFamily: 'Urbanist-Bold', color: Colors.black),
            );
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  if (cart.products.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/Frame.png"),
                            SizedBox(height: 20),
                            Text(
                              "Empty",
                              style: TextStyle(fontSize: 20, fontFamily: 'Urbanist-Bold', color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "You do not have an active order at this time",
                              style: TextStyle(fontSize: 20, fontFamily: 'Urbanist-Regular'),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    double subtotal = calculateSubtotal(cart);
                    double deliveryFee = 2;
                    double total = subtotal + deliveryFee;

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(15),
                            itemCount: cart.products.length,
                            separatorBuilder: (context, index) => Divider(color: Colors.grey[300]),
                            itemBuilder: (context, index) {
                              final product = cart.products[index];
                              final double price = double.tryParse(product.product['price']?.toString() ?? '0') ?? 0;
                              final quantity = product.quantity ?? 1;
                              final totalPrice = price * quantity;

                              return InkWell(
                                onTap: () {},
                                child: Card(
                                  elevation: 0,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(
                                                product.product['mainImage'],
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        product.product['name'],
                                                        style: const TextStyle(
                                                          fontFamily: 'Urbanist-Bold',
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.all(8.0),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          border: Border.all(color: successColor, width: 2.0),
                                                        ),
                                                        child: Text(
                                                          '$quantity X',
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: "Urbanist-Bold",
                                                            color: successColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    product.product['description'],
                                                    style: const TextStyle(
                                                      fontFamily: "Urbanist-Medium",
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${totalPrice.toStringAsFixed(2)} DT',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "Urbanist-Bold",
                                                          color: successColor,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: IconButton(
                                                          icon: const Icon(Icons.delete, color: errorColor, size: 22),
                                                          onPressed: () {
                                                            Provider.of<CartProvider>(context, listen: false).remove(product);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Subtotal",
                                    style: const TextStyle(
                                      fontFamily: "Urbanist-Medium",
                                      fontSize: 14,
                                    ),),
                                  Text("${subtotal.toStringAsFixed(2)} DT",
                                    style: const TextStyle(
                                      fontFamily: "Urbanist-Medium",
                                      fontSize: 14,
                                    ),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Delivery Fee",
                                    style: const TextStyle(
                                      fontFamily: "Urbanist-Medium",
                                      fontSize: 14,
                                    ),),
                                  Text("${deliveryFee.toStringAsFixed(2)} DT",
                                    style: const TextStyle(
                                      fontFamily: "Urbanist-Medium",
                                      fontSize: 14,
                                    ),),
                                ],
                              ),
                              const Divider(color: Colors.grey),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total",
                                    style: const TextStyle(
                                      fontFamily: "Urbanist-Bold",
                                      fontSize: 16,
                                    ),),
                                  Text("${total.toStringAsFixed(2)} DT",
                                    style: const TextStyle(
                                      fontFamily: "Urbanist-Bold",
                                      fontSize: 16,
                                    ),),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  makeOrder();
                                },
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
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
