import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpeacialOffersWidget extends StatefulWidget {
  const SpeacialOffersWidget({super.key});

  @override
  State<SpeacialOffersWidget> createState() => _SpeacialOffersWidgetState();
}

class _SpeacialOffersWidgetState extends State<SpeacialOffersWidget> {
  @override
  Widget build(BuildContext) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/food.png',
              height: 120,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Text(
                  "30% \ndiscount only \nvalid for today!",
                  style: TextStyle(
                      fontFamily: "Lucky-font",
                      fontSize: 21,
                      color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
