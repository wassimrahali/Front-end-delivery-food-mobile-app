import 'package:Foodu/models/Card.model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool _isCreatingOrder = false; // Initially set to false
  String userLocation = '';

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
    setState(() {
      userLocation = "${position.latitude}, ${position.longitude}";
    });
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
    setState(() {
      _isCreatingOrder = true;  // Start loading
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
        "status": "NOT_VALIDATED",
        "deliveryManId": 2,
        "customerId": widget.userId,
        "orderItems": orderItems,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.createOrder),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Order added to cart successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: successColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to create order. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: errorColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: errorColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isCreatingOrder = false;  // Stop loading once the process is done
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocationApp();
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
                      padding: const EdgeInsets.all(20),
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
                            Center(child: Text(
                              "You don't have an active order at this time",
                              style: TextStyle(fontSize: 20, fontFamily: 'Urbanist-Regular'),
                            )),
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
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(color: Colors.grey[300]!),
                              bottom: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: successColor, size: 24),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Deliver to",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Urbanist-Medium",
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      userLocation.isNotEmpty ? userLocation : "Fetching location...",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Urbanist-Bold",
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey[600]),
                            ],
                          ),
                        ),
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
                                                          borderRadius: BorderRadius.circular(10.0),
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

                                                        child: IconButton(
                                                          icon: const Icon(Icons.delete_outline_outlined, color: errorColor, size: 22),
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
                          padding: EdgeInsets.all(20),
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
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: _isCreatingOrder ? null : makeOrder,
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _isCreatingOrder
                                          ? [Colors.grey.shade400, Colors.grey.shade500]
                                          : [Color(0xFF4CAF50), Color(0xFF45A049)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(minWidth: double.infinity, minHeight: 56),
                                    alignment: Alignment.center,
                                    child: _isCreatingOrder
                                        ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          "CREATING ORDER...",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: "Urbanist-Bold"
                                          ),
                                        ),
                                      ],
                                    )
                                        : Text(
                                      "ADD TO CART",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: "Urbanist-Bold"
                                      ),
                                    ),
                                  ),
                                ),
                              )
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
