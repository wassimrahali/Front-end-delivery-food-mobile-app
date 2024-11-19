import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/Order.model.dart';
import '../utils/api_constants.dart';
import '../utils/colors.dart';

class Orderscreen extends StatefulWidget {
  final int userId;
  const Orderscreen({super.key, required this.userId});

  @override
  State<Orderscreen> createState() => _OrderscreenState();
}

class _OrderscreenState extends State<Orderscreen> {
  List<Order> _orders = [];
  bool _isLoading = true;
  bool _hasError = false;
  Map<int, bool> _expandedItems = {};

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getOrderById + widget.userId.toString()),
      );

      if (response.statusCode == 200) {
        try {
          final List<dynamic> ordersJson = jsonDecode(response.body);
          _orders = ordersJson.map((orderJson) => Order.fromJson(orderJson)).toList();
          setState(() {
            _isLoading = false;
          });
        } catch (e) {
          print("Error decoding JSON: $e");
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      } else {
        print("Failed to fetch orders: ${response.statusCode}");
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching orders: $e");
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Color getOrderStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'NOT_VALIDATED':
        return errorColor;
      case 'VALIDATED':
        return Colors.blueAccent;
      case 'DELIVERED':
        return successColor;
      case 'CANCELLED':
        return errorColor;
      default:
        return disabledColor;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Urbanist-Bold',
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: successColor,
              ),
            );
          } else if (_hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: errorColor,
                    size: 60,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Error loading orders',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Urbanist-Medium',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: _fetchOrders,
                    child: Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Urbanist-Bold',
                        color: successColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (_orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/Frame.png",
                    height: 200,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No Orders Yet",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Urbanist-Bold',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Start ordering to see your orders here",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Urbanist-Regular',
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(

              padding: EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                final status = order.status ?? 'Unknown';
                final statusColor = getOrderStatusColor(status);
                final totalPrice = order.totalPrice.toString();
                final orderItems = order.orderItems;
                bool isDetailsExpanded = _expandedItems[index] ?? false;

                return Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${index + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist-Bold',
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              //status *******************
                              '${status.replaceAll("_", " ")}',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Urbanist-SemiBold',
                                color: getOrderStatusColor(status),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _expandedItems[index] = !isDetailsExpanded;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                'Order details',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Urbanist-Regular',
                                ),
                              ),
                              Icon(
                                isDetailsExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                              ),
                            ],
                          ),
                        ),
                        if (isDetailsExpanded) ...[
                          SizedBox(height: 16),
                          // ... Previous code remains the same until the order items mapping ...

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: orderItems.map((item) {
                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    // Product Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        item.product.mainImage,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Container(
                                        height: 100, // Match image height for consistency
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    item.product.name,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Urbanist-Regular',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Quantity Circle - Always aligned to the right
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color.fromRGBO(219, 234, 254, 1),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                "x${item.quantity.toString()}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Urbanist-Regular',
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        ],
                        Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Amount",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist-Medium',
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "$totalPrice DT",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist-Bold',
                                color: successColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
