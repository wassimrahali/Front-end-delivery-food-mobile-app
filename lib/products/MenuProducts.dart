import 'package:Foodu/products/productsDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../utils/colors.dart';

class MenuProducts extends StatefulWidget {
  final Map<String, dynamic> data;

  const MenuProducts({Key? key, required this.data}) : super(key: key);

  @override
  State<MenuProducts> createState() => _MenuProductsState();
}

class _MenuProductsState extends State<MenuProducts> {
  @override
  Widget build(BuildContext context) {
    final categoryName = widget.data["name"];
    final categoryProducts = widget.data["products"];

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Filter button
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: successColor, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset("assets/images/Filter.png"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Filter",
                            style: TextStyle(
                              fontFamily: "Urbanist-Medium",
                              fontSize: 14,
                              color: successColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Sort button
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: successColor, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset("assets/images/Sort.png"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Sort",
                            style: TextStyle(
                              fontFamily: "Urbanist-Medium",
                              fontSize: 14,
                              color: successColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: successColor, width: 2),
                      ),
                      child: Center( // Centers the text vertically and horizontally
                        child: Text(
                          "Promo",
                          style: TextStyle(
                            fontFamily: "Urbanist-Medium",
                            fontSize: 14,
                            color: successColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryProducts.length,
              itemBuilder: (context, index) {
                final product = categoryProducts[index];
                return InkWell(

                    onTap: () {
                      print(product["name"]); // Add this line to see what product data looks like
                      Get.to(() => Productsdetails(product: product, categoryName: categoryName));
                  },child:Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product['mainImage'],
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
                              Text(
                                product['name'],
                                style: const TextStyle(
                                  fontFamily: 'Urbanist-Bold',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              // Description
                              Text(
                                product['description'],
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
                                  const Icon(Icons.delivery_dining, color: Colors.green, size: 16),
                                  Text(
                                    '\$${product['price']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Urbanist-Medium",
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ) ,) ;
              },
            ),

          ],
        ),
      ),
    );
  }
}