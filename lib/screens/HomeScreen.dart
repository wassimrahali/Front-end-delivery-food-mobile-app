
import 'package:Foodu/screens/productsDetails.dart';
import 'package:Foodu/utils/colors.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildSpecialOffers(),
            const SizedBox(height: 20),
            _buildCategories(),
            const SizedBox(height: 20),
            _buildDiscountSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile_pic.png'),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deliver to', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Row(
                  children: [
                    Text('Times Square', style: TextStyle(fontFamily: "Urbanist-Bold")),
                    Icon(Icons.keyboard_arrow_down, color: Colors.green, size: 16),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(icon: Icon(Icons.notifications_outlined), onPressed: () {}),
            IconButton(icon: Icon(Icons.shopping_bag_outlined), onPressed: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'What are you craving?',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildSpecialOffers() {
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
                Text("30% \n discount only \n valid for today!",style: TextStyle(fontFamily:"Lucky-font",fontSize: 20,color: Colors.white),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'icon': Icons.fastfood, 'name': 'Hambur..'},
      {'icon': Icons.local_pizza, 'name': 'Pizza'},
      {'icon': Icons.ramen_dining, 'name': 'Noodles'},
      {'icon': Icons.restaurant, 'name': 'Meal'},
      {'icon': Icons.eco, 'name': 'Vegeta..'},
      {'icon': Icons.cake, 'name': 'Dessert'},
      {'icon': Icons.local_bar, 'name': 'Drink'},
      {'icon': Icons.more_horiz, 'name': 'More'},
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Categories', style: TextStyle(fontSize: 18, fontFamily: "Urbanist-Bold")),
            TextButton(
              onPressed: () {},
              child: Text('See All', style: TextStyle(color: successColor,fontFamily: "Urbanist-Bold")),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.1),
                  child: Icon(categories[index]['icon'] as IconData, color: Colors.green),
                ),
                SizedBox(height: 5),
                Text(categories[index]['name'] as String, style: TextStyle(fontSize: 12)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDiscountSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Discount Guaranteed! 👌', style: TextStyle(fontSize: 18, fontFamily: "Urbanist-Bold",)),
            TextButton(
              onPressed: () {},
              child: Text('See All', style: TextStyle(color: successColor,fontFamily: "Urbanist-Bold")),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildDiscountCard(context)), // Pass context here
            const SizedBox(width: 10),
            Expanded(child: _buildDiscountCard(context)), // Pass context here
          ],
        ),
      ],
    );
  }

  Widget _buildDiscountCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Productsdetails()),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                "assets/images/salads.jpg",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'PROMO',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fresh Salads',
                        style: TextStyle(
                          fontFamily: "Urbanist-Bold",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Healthy and delicious options',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




