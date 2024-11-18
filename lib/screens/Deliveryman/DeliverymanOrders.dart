import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Foodu/utils/api_constants.dart';
import 'package:Foodu/utils/colors.dart';
import 'package:flutter/services.dart';
class DeliverymanOrders extends StatefulWidget {
  const DeliverymanOrders({super.key});

  @override
  State<DeliverymanOrders> createState() => _DeliverymanOrdersState();
}

class _DeliverymanOrdersState extends State<DeliverymanOrders> {
  List<dynamic> _orders = [];
  Map<int, bool> _expandedItems = {};
  Map<String, String> _addressCache = {};
  bool isLoading = true;
  double myLatitude = 0.0;
  double myLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getOrdersData();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Les services de localisation sont désactivés.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Les permissions de localisation sont refusées.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Les permissions de localisation sont définitivement refusées.';
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      myLatitude = position.latitude;
      myLongitude = position.longitude;
    });
  }

  Future<void> getOrdersData() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.getAOrdersByStatus + 'VALIDATED'));
      if (response.statusCode == 200) {
        List<dynamic> orders = jsonDecode(response.body);

        // Récupérer les adresses
        for (var order in orders) {
          String location = order['location'] ?? '';
          if (location.isNotEmpty) {
            order['locationName'] = await getAddressFromCoordinates(location);
          } else {
            order['locationName'] = 'Localisation inconnue';
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
      print("Error fetching orders: $error");
    }
  }

  Future<String> getAddressFromCoordinates(String coordinates) async {
    if (_addressCache.containsKey(coordinates)) {
      return _addressCache[coordinates]!;
    }

    final latLng = coordinates.split(',');
    if (latLng.length != 2) return 'Localisation invalide';

    final lat = latLng[0].trim();
    final lng = latLng[1].trim();

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String address = data['display_name'] ?? 'Localisation inconnue';

        // Simplifier l'adresse (jusqu'au deuxième niveau)
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
        return 'Localisation introuvable';
      }
    } catch (error) {
      print("Erreur lors de la géocodification inverse : $error");
      return 'Localisation non disponible';
    }
  }

  void openGoogleMaps(String coordinates) async {
    final Uri googleMapsUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$myLatitude,$myLongitude&destination=$coordinates&travelmode=driving');

    if (!await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication)) {
      throw 'Impossible d’ouvrir Google Maps.';
    }
  }

  void CallCustemer(String phone) async {
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Numéro de téléphone invalide.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final Uri telUri = Uri(scheme: 'tel', path: phone.trim());

    print('Numéro de téléphone : $phone');
    print('URI générée : $telUri');

    try {
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri, mode: LaunchMode.externalApplication);
        print('Appel lancé avec succès.');
      } else {
        throw 'Aucune application disponible pour passer un appel.';
      }
    } catch (error) {
      print('Erreur : $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text(
                "Impossible d'ouvrir l'application d'appel. Voulez-vous copier le numéro pour l'utiliser manuellement ?"),
            actions: [
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: phone));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Numéro copié dans le presse-papiers.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text('Copier le numéro'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Annuler'),
              ),
            ],
          );
        },
      );
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, index) {
            final order = _orders[index];
            final status = order['status'] ?? 'Unknown';
            final statusColor = getOrderStatusColor(status);
            final totalPrice = order['totalPrice'] ?? '0';
            final location = order['location'] ?? '0,0';
            final locationName = order['locationName'] ?? 'Localisation inconnue';
            final orderItems = order['orderItems'] ?? [];
            bool isDetailsExpanded = _expandedItems[index] ?? false;

            return Card(
              elevation: 0,
              shadowColor: Colors.black54,
              color: Colors.black54,
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
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            color: Colors.white,
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['product']['name'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Urbanist-Regular',
                                        ),
                                      ),
                                      Text(
                                        '${item['product']['price']} DT',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Urbanist-Regular',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    Divider(height: 24, color: Colors.white),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Urbanist-SemiBold',
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${totalPrice.toString()} DT',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Urbanist-SemiBold',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24, color: Colors.white),
                    Row(children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => openGoogleMaps(location),
                      child: Text("Naviguer avec Google Maps"),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: successColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => CallCustemer("+21624961175"),
                      child: Icon(Icons.phone)),],),
                    Divider(height: 24,color: Colors.white),
                    Center(
                      child: Row(children: [
                        MaterialButton(color: successColor,child:Text("Livrer"),textColor: Colors.white,onPressed: (){}),
                        SizedBox(width: 20,),
                        MaterialButton(color:Colors.red,child:Text("Annuler"),textColor: Colors.white,onPressed: (){})],),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
