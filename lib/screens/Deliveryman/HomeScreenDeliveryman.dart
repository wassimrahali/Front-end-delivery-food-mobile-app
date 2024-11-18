import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Foodu/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:Foodu/utils/api_constants.dart';
class Homescreendeliveryman extends StatefulWidget {
  const Homescreendeliveryman({super.key});

  @override
  State<Homescreendeliveryman> createState() => _HomescreendeliverymanState();
}

class _HomescreendeliverymanState extends State<Homescreendeliveryman> {
  List<dynamic> _orders = [];
  Map<int, bool> _expandedItems = {};
  Map<String, String> _addressCache = {};
  int id=2;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getOrdersData();
  }

  Future<void> getOrdersData() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.getAOrdersByStatus+'NOT_VALIDATED'));
      if (response.statusCode == 200) {
        List<dynamic> orders = jsonDecode(response.body);
        isLoading=false;
        for (var order in orders) {
          String location = order['location'] ?? '';
          if (location.isNotEmpty) {
            order['locationName'] = await getAddressFromCoordinates(location);
          } else {
            order['locationName'] = 'Unknown location';
          }
        }


        setState(() {
          _orders = orders;
        });
      } else {
        throw Exception('Failed to fetch orders: ${response.reasonPhrase}');
      }
    } catch (error) {
      print("Error fetching orders: $error");
    }
  }
  Future<void> updateOrderStatus(int id) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConstants.UpdateOrderDataById +' ${id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': 'VALIDATED',"id":id}),
      );

      if (response.statusCode == 200) {
        print("Order status updated to VALIDATED");
      } else {
        print("Failed to update order status: ${response.statusCode}");
      }
    } catch (error) {
      print("Error updating order status: $error");
    }
  }


  Future<String> getAddressFromCoordinates(String coordinates) async {
    if (_addressCache.containsKey(coordinates)) {
      return _addressCache[coordinates]!;
    }

    final latLng = coordinates.split(',');
    if (latLng.length != 2) return 'Invalid location';

    final lat = latLng[0].trim();
    final lng = latLng[1].trim();

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String address = data['display_name'] ?? 'Unknown location';

        int commaCount = 0;
        int index = 0;
        for (int i = 0; i < address.length; i++) {
          if (address[i] == ',') {
            commaCount++;
          }
          if (commaCount == 2) {
            index = i;
            break;
          }
        }
        if (commaCount >= 2) {
          address = address.substring(0, index);
        }

        _addressCache[coordinates] = address;
        return address;
      } else {
        return 'Location not found';
      }
    } catch (error) {
      print("Error reverse geocoding: $error");
      return 'Location not available';
    }
  }


  Color getOrderStatusColor(String status) {
    switch (status) {
      case 'VALIDATED':
        return Colors.green;
      case 'NOT_VALIDATED':
        return Colors.orange;
      case 'Canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body:Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _orders.length,
            itemBuilder: (context, index) {
              final order = _orders[index];
              final status = order['status'] ?? 'Unknown';
              final statusColor = getOrderStatusColor(status);
              final totalPrice = order['totalPrice'] ?? '0';
              final location = order['locationName'] ?? 'Unknown location';
              final orderItems = order['orderItems'] ?? [];
              bool isDetailsExpanded = _expandedItems[index] ?? false;

              return Card(
                elevation: 0,
                shadowColor: Colors.black54,
                color:Colors.black54,
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
                            'Order #${order['id']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Urbanist-Bold',
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${status.replaceAll("_", " ")}',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Urbanist-SemiBold',
                              color: statusColor,
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
                                  color: Colors.white
                              ),
                            ),
                            Icon(color: Colors.white,
                              isDetailsExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                          ],
                        ),
                      ),
                      if (isDetailsExpanded) ...[
                        SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: orderItems.map<Widget>((item) {
                            return Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      item['product']['mainImage'],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      height: 100,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  item['product']['name'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily:
                                                    'Urbanist-Regular',
                                                  ),
                                                ),
                                                Text(
                                                  '${item['product']['price']} DT',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily:
                                                    'Urbanist-Regular',
                                                    color: Colors.white,
                                                  ),
                                                ),

                                                Icon(Icons.map),
                                                Text(
                                                  location,
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontFamily:
                                                    'Urbanist-Regular',
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  219, 234, 254, 1),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "x${item['quantity']}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Urbanist-Regular',
                                                color: Colors.white,
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
                        ),
                      ],
                      Divider(height: 24,color: Colors.white),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist-Medium',
                                color: Colors.white
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
                      Divider(height: 24,color: Colors.white),
                      Center(
                        child: Row(children: [
                          MaterialButton(color: successColor,child:Text("accepter"),textColor: Colors.white,onPressed: (){updateOrderStatus(order['id']); }),
                          SizedBox(width: 20,),
                          MaterialButton(color:Colors.red,child:Text("refuser"),textColor: Colors.white,onPressed: (){})],),
                      )
                    ],
                  ),

                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
