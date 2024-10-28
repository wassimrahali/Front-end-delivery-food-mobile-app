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
        title: Text(categoryName,style: TextStyle(fontSize: 20, fontFamily: 'Urbanist-Bold', color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,


        ),
      ),
      body: Container(

        decoration: BoxDecoration(
          color: Colors.white,
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
                        border: Border.all(color: successColor, width: 1),
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
                              child:Icon(Icons.filter_alt_outlined,color: successColor,),
                            ),
                          ),
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
                        border: Border.all(color: successColor, width: 1),
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
                              child: Icon(Icons.sort,color:successColor ,)
                            ),
                          ),
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
                        border: Border.all(color: successColor, width: 1),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Ensures the row takes up only the necessary space
                          children: [
                            Icon(
                              Icons.local_offer, // Promotion icon
                              size: 16,
                              color: successColor,
                            ),
                            const SizedBox(width: 5), // Adds a small space between the icon and text
                            Text(
                              "Promo",
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
                      Get.to(() => Productsdetails(product: product, categoryName: categoryName, quantity: null,));
                  },child:Card(
                  elevation: 0,
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
                                  const Icon(Icons.delivery_dining, color: successColor, size: 22),
                                  Text(
                                    '${product['price']} DT',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Urbanist-Bold",
                                      color: successColor,
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
