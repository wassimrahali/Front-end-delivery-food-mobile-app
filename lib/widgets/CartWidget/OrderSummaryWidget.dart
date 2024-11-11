import 'package:flutter/material.dart';

import 'SummaryRowWidget.dart';

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;
  final bool isCreatingOrder;
  final VoidCallback makeOrder;
  final Color successColor;

  const OrderSummary({
    Key? key,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.isCreatingOrder,
    required this.makeOrder,
    required this.successColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SummaryRowWidget(label: "Subtotal", amount: subtotal),
            SizedBox(height: 8),
            SummaryRowWidget(label: "Delivery Fee", amount: deliveryFee),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Colors.grey[300]),
            ),
            SummaryRowWidget(label: "Total", amount: total, isTotal: true),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: isCreatingOrder ? null : makeOrder,
              child: Ink(
                decoration: BoxDecoration(
                  color: isCreatingOrder ? Colors.grey[500] : successColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  alignment: Alignment.center,
                  child: isCreatingOrder
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "CREATING ORDER...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Urbanist-Bold",
                        ),
                      ),
                    ],
                  )
                      : Text(
                    "PLACE ORDER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Urbanist-Bold",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
