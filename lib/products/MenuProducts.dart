import 'package:Foodu/products/productsDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

class MenuProducts extends StatefulWidget {
  final Map<String, dynamic> data;

  const MenuProducts({Key? key, required this.data}) : super(key: key);

  @override
  State<MenuProducts> createState() => _MenuProductsState();
}

class _MenuProductsState extends State<MenuProducts> {
  late List<dynamic> categoryProducts;
  double? startPrice;
  double? endPrice;

  @override
  void initState() {
    super.initState();
    categoryProducts = widget.data["products"]; // Initialize products
  }

  void showFilterDialog() {
    final TextEditingController startPriceController = TextEditingController();
    final TextEditingController endPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Filter by Price Range",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Urbanist-Bold",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: startPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Start Price",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: endPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "End Price",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: errorColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          startPrice = double.tryParse(startPriceController.text);
                          endPrice = double.tryParse(endPriceController.text);
                          filterByPriceRange();
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: successColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Apply",style: TextStyle(
                        fontFamily: "Urbanist-Medium",
                        color: Colors.white,
                        fontSize: 16
                      ),),
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

  void filterByPriceRange() {
    if (startPrice != null && endPrice != null) {
      setState(() {
        categoryProducts = widget.data["products"].where((product) {
          final price = double.tryParse(product['price']);
          return price != null && price >= startPrice! && price <= endPrice!;
        }).toList();
      });
    }
  }

  void sortByPrice() {
    setState(() {
      categoryProducts.sort((a, b) {
        double priceA = double.parse(a['price']);
        double priceB = double.parse(b['price']);
        return priceA.compareTo(priceB);
      });
    });
  }

  void showPromoMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No product with promo this time."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.data["name"];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Urbanist-Bold',
            color: Colors.black,
          ),
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
                    child: GestureDetector(
                      onTap: showFilterDialog,
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
                  ),
                  const SizedBox(width: 16),
                  // Sort button
                  Expanded(
                    child: GestureDetector(
                      onTap: sortByPrice,
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
                                child:Icon(Icons.sort,color: successColor,),
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
                  ),
                  const SizedBox(width: 16),
                  // Promo button
                  Expanded(
                    child: GestureDetector(
                      onTap: showPromoMessage,
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
                                child:Icon(Icons.local_offer,color: successColor,),
                              ),
                            ),
                            const Text(
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
                    Get.to(() => Productsdetails(
                      product: product,
                      categoryName: categoryName,
                      quantity: null,
                    ));
                  },
                  child: Card(
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
