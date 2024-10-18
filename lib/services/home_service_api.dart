import 'dart:convert';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:Foodu/products/productsDetails.dart';
import 'package:Foodu/utils/colors.dart';

import 'package:http/http.dart';

class GetHome{

  Future<List<dynamic>> GetData() async {
    final response = await get(Uri.parse("http://192.168.1.2:8000/api/categories"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Échec de la récupération des catégories');
    }
  }

  Future<List<dynamic>> GetProductData() async {
    final response = await get(Uri.parse("http://192.168.1.2:8000/api/products"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Échec de la récupération des produits');
    }
  }

}