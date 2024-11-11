import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../../products/productsDetails.dart';
import '../../utils/api_constants.dart';

class SearchbarWidget extends StatefulWidget {
  const SearchbarWidget({super.key});

  @override
  State<SearchbarWidget> createState() => _SearchbarWidgetState();
}

class _SearchbarWidgetState extends State<SearchbarWidget> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _allProducts = [];
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  // Fetch all products once at the beginning
  Future<void> _fetchAllProducts() async {


    try {
      final response = await http.get(Uri.parse(ApiConstants.getAllProducts));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            _allProducts = data;
            _searchResults = []; // Initialize search results as empty
          });
        } else {
          print('Unexpected response format');
        }
      } else {
        print('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Filter products based on the search term
  void _filterProducts(String query) {
    if (query.isNotEmpty) {
      final filteredProducts = _allProducts.where((product) {
        final productName = product['name'].toLowerCase();
        return productName.contains(query.toLowerCase());
      }).toList();

      setState(() {
        _searchResults = filteredProducts;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
    _searchController.addListener(() {
      _filterProducts(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'What are you craving?',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        if (_isLoading)
          const CircularProgressIndicator()
        else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
          const Text('No results found')
        else if (_searchResults.isNotEmpty)
            Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return InkWell( onTap: () {
                    Get.to(() => Productsdetails(
                      product: result,
                      categoryName: result['category']['name'] ?? 'Unknown', quantity: null,
                    ));
                  }, child:ListTile(
                    title: Text(result['name'] ?? 'No name'),
                    //subtitle: Text(result['description'] ?? 'No description'),
                     leading: Image.network(
                      result['mainImage'] ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image);
                      },
                    ),
                    trailing: Text('\$${result['price']}'),
                  ) ,);
                },
              ),
            ),
      ],
    );
  }
}
