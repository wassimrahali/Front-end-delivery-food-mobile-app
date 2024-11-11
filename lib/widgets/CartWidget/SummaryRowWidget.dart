import 'package:flutter/material.dart';

class SummaryRowWidget extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const SummaryRowWidget({
    Key? key,
    required this.label,
    required this.amount,
    this.isTotal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontFamily: isTotal ? "Urbanist-Bold" : "Urbanist-Medium",
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          "${amount.toStringAsFixed(2)} DT",
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontFamily: isTotal ? "Urbanist-Bold" : "Urbanist-Medium",
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
