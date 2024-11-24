import 'dart:convert';
import 'package:Foodu/widgets/CartWidget/EmptyCart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Foodu/utils/colors.dart'; // Importez vos couleurs personnalisées
import 'package:Foodu/utils/api_constants.dart'; //

class Homescreendeliveryman extends StatefulWidget {
  final int id;
  const Homescreendeliveryman({Key? key, required this.id}) : super(key: key);


  @override
  State<Homescreendeliveryman> createState() => _HomescreendeliverymanState();
}

class _HomescreendeliverymanState extends State<Homescreendeliveryman> {
  List<dynamic> _orders = [];
  Map<int, bool> _expandedItems = {};
  Map<String, String> _addressCache = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getOrdersData();
  }

  // Récupère les données des commandes depuis l'API
  Future<void> getOrdersData() async {
    try {
      final response = await http.get(
          Uri.parse(ApiConstants.getAOrdersByStatus + 'VALIDATED'));
      if (response.statusCode == 200) {
        List<dynamic> orders = jsonDecode(response.body);

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
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch orders: ${response.reasonPhrase}');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching orders: $error")),
      );
    }
  }

  // Met à jour le statut d'une commande
  Future<void> updateOrderStatus(int id, String newStatus) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConstants.UpdateOrderDataById + '$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': newStatus, "deliveryManId": widget.id}),
      );

      if (response.statusCode == 200) {
        setState(() {
          final orderIndex = _orders.indexWhere((order) => order['id'] == id);
          if (orderIndex != -1) {
            _orders[orderIndex]['status'] = newStatus;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order status updated to $newStatus")),
        );
      } else {
        throw Exception(
            'Failed to update order status: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating order status: $error")),
      );
    }
  }

  // Convertit les coordonnées en adresse lisible
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

        // Extraction des informations spécifiques
        final addressParts = data['address'];
        if (addressParts != null) {
          final String street = addressParts['road'] ?? '';
          final String city = addressParts['city'] ?? addressParts['town'] ??
              addressParts['village'] ?? '';
          final String country = addressParts['country'] ?? '';

          // Construire une adresse plus courte
          final List<String> shortAddress = [street, city, country].where((
              part) => part.isNotEmpty).toList();
          final simplifiedAddress = shortAddress.join(', ');

          _addressCache[coordinates] = simplifiedAddress;
          return simplifiedAddress;
        } else {
          return 'Address not found';
        }
      } else {
        return 'Location not found';
      }
    } catch (error) {
      return 'Location not available';
    }
  }

  // Définit les couleurs en fonction du statut
  Color getOrderStatusColor(String status) {
    switch (status) {
      case 'VALIDATED':
        return Colors.green;
      case 'ON_ROAD':
        return Colors.orange;
      case 'Canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Construit chaque commande
  Widget buildOrderItem(Map<String, dynamic> order, int index) {
    final status = order['status'] ?? 'Unknown';
    final statusColor = getOrderStatusColor(status);
    final totalPrice = order['totalPrice'] ?? '0';
    final location = order['locationName'] ?? 'Unknown location';
    final orderItems = order['orderItems'] ?? [];
    bool isDetailsExpanded = _expandedItems[index] ?? false;

    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order['id']}',
                  style: const TextStyle(fontSize: 16,
                      fontFamily: 'Urbanist-Bold',
                      color: Colors.black),
                ),
                Text(
                  status.replaceAll("_", " "),
                  style: TextStyle(fontSize: 14,
                      fontFamily: 'Urbanist-SemiBold',
                      color: statusColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _expandedItems[index] = !isDetailsExpanded;
                });
              },
              child: Row(
                children: [
                  const Text(
                    'Order details',
                    style: TextStyle(fontSize: 14,
                        fontFamily: 'Urbanist-Regular',
                        color: Colors.black),
                  ),
                  Icon(
                    isDetailsExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            if (isDetailsExpanded) ...[
              const SizedBox(height: 16),
              ...orderItems.map<Widget>((item) {
                return ListTile(
                  leading: Image.network(
                    item['product']['mainImage'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item['product']['name']),
                  subtitle: Text(
                      '${item['quantity']} x ${item['product']['price']} DT'),
                );
              }).toList(),
            ],
            const Divider(height: 24, color: Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(fontSize: 16,
                      fontFamily: 'Urbanist-Medium',
                      color: Colors.black),
                ),
                Text(
                  "$totalPrice DT",
                  style: TextStyle(fontSize: 16,
                      fontFamily: 'Urbanist-Bold',
                      color: successColor),
                ),
              ],
            ),
            const Divider(height: 24, color: Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  color: successColor,
                  child: const Text("Accept"),
                  textColor: Colors.white,
                  onPressed: () => updateOrderStatus(order['id'], 'ON_ROAD'),
                ),
                const SizedBox(width: 20),
                MaterialButton(
                  color: Colors.red,
                  child: const Text("Reject"),
                  textColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _orders.removeAt(index); // Supprime l'élément de la liste
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _orders.isEmpty
            ? Center(
          child: EmptyCart(), // Affiche le widget EmptyCart si aucune commande n'est disponible
        )
            : ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, index) =>
              buildOrderItem(_orders[index], index),
        ),
      ),
    );
  }
}
