import 'package:Foodu/Cartscreen/Cartscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HeaderWidget extends StatefulWidget {
  final String userName;

  final int userId; // Add a parameter for userName
  const HeaderWidget({
    super.key,
    required this.userName,
    required this.userId,// Require userName
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/images/avatar.png'),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Deliver to",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Row(
                  children: [
                    Text(
                      widget.userName, // Access userName from the widget
                      style: const TextStyle(fontFamily: "Urbanist-Bold"),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.green,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined),
              onPressed: () {
                Get.to(Cardscreen(userId: widget.userId));
              },
            ),
          ],
        ),
      ],
    );
  }
}
