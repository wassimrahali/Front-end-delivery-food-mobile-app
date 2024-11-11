import 'package:flutter/material.dart';

import '../../models/Card.model.dart';

class ProductItemWidget extends StatelessWidget {
  final dynamic product;
  final CartProvider cart;
  final Color successColor;

  const ProductItemWidget({
    Key? key,
    required this.product,
    required this.cart,
    required this.successColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double price = double.tryParse(product.product['price']?.toString() ?? '0') ?? 0;
    final int quantity = product.quantity ?? 1;
    final double totalPrice = price * quantity;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.product['mainImage'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.product['name'],
                        style: TextStyle(
                          fontFamily: 'Urbanist-Bold',
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$quantity x',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Urbanist-Bold",
                          color: successColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${totalPrice.toStringAsFixed(2)} DT',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Urbanist-Bold",
                        color: successColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                      onPressed: () => cart.remove(product),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
