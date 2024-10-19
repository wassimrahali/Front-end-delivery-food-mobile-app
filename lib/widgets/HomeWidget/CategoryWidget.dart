import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Foodu/utils/colors.dart'; // Ensure you have your color constants available.

class CategoryWidget extends StatefulWidget {
  final List<dynamic> categories; // Add a parameter for categories

  const CategoryWidget({
    super.key,
    required this.categories, // Make sure to require categories
  });

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    // Use the categories passed to this widget
    if (widget.categories.isEmpty) {
      return Center(child: Text('No categories available'));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontFamily: "Urbanist-Bold"),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(color: successColor, fontFamily: "Urbanist-Bold"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
          ),
          itemCount: widget.categories.length, // Use widget.categories
          itemBuilder: (context, index) {
            final category = widget.categories[index]; // Use widget.categories
            return Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.1),
                  radius: 30,
                  child: Image.network(
                    category['image'],
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  category['name'],
                  style: TextStyle(fontSize: 12),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
