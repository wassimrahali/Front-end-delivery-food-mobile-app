import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../products/productsDetails.dart';

class CartProvider extends ChangeNotifier {
  final List<Productsdetails> _products = [];

  UnmodifiableListView<Productsdetails> get products => UnmodifiableListView(_products);

  void add(Map<String, dynamic> productData,int quantity) {
    Productsdetails product = Productsdetails(
      product: productData,quantity:quantity,
      categoryName: productData['category']?['name'] ?? 'Default Category', // Provide a fallback
    );
    _products.add(product);
    print("added ${product}");
    print("quantite ${quantity}");
    notifyListeners();
  }
  void remove(product){
    _products.remove(product);
    notifyListeners();
  }
}
