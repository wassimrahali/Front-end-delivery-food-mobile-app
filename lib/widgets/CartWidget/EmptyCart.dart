import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/Frame.png",
              height: 180,
            ),
            SizedBox(height: 24),
            Text(
              "Empty",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Urbanist-Bold',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "You don't have an active order at this time",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Urbanist-Medium',
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
