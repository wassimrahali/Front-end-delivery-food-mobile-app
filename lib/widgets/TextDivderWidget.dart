import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextDividerWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double thickness;
  final Color color;

  const TextDividerWidget({
    Key? key,
    required this.text,
    this.textStyle,
    this.thickness = 1.5,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: thickness,
            color: color,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            style: textStyle ?? TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontFamily: 'Urbanist-SemiBold',
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: thickness,
            color: color,
          ),
        ),
      ],
    );
  }
}
