import 'package:Foodu/screens/Products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../utils/colors.dart';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyappState();
}

class _MyappState extends State<Home> {
  TextEditingController username = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // Déplacer Menus en dehors de build
  List<Map<String, dynamic>> Menus = [
    {"name": "Burger", "image": "assets/images/hamburger.png", "description": "this is burger menu", "prix": 5, "isFavorite": false,"favorites":0,
      "products": [
        {"name": "Cheeseburger", "price": 5,"image":"assets/images/MaskGroup.png"},
        {"name": "Bacon Burger", "price": 6,"image":"assets/images/MaskGroup.png"},
      ]},
    {"name": "salads", "image": "assets/images/vegetable.png", "description": "this is burger menu", "prix": 5, "isFavorite": false,"favorites":0,
      "products": [
        {"name": "Cheeseburger", "price": 5,"image":"assets/images/vegetable.png"},
        {"name": "Bacon Burger", "price": 6,"image":"assets/images/vegetable.png"},
      ]},
    {"name": "Pizza", "image": "assets/images/pizza.png", "description": "this is pizzas menu", "prix": 8, "isFavorite": false,
      "products": [
        {"name": "Cheeseburger", "price": 5,"image":"assets/images/pizza.png"},
        {"name": "Bacon Burger", "price": 6,"image":"assets/images/pizza.png"},
      ]},
    {"name": "Burger", "image": "assets/images/hamburger.png", "description": "this is burger menu", "prix": 5, "isFavorite": false,"favorites":0,
      "products": [
        {"name": "Cheeseburger", "price": 5,"image":"assets/images/MaskGroup.png","description": "this is burger menu"},
        {"name": "Bacon Burger", "price": 6,"image":"assets/images/MaskGroup.png","description": "this is burger menu"},
      ]},
    {"name": "Pizza", "image": "assets/images/pizza.png", "description": "this is pizzas menu", "prix": 8, "isFavorite": false,"products": [
      {"name": "Cheeseburger", "price": 5,"image":"assets/images/pizza.png","description": "this is pizza menu"},
      {"name": "Bacon Burger", "price": 6,"image":"assets/images/pizza.png","description": "this is pizza menu"},
    ]
    },
    {"name": "Burger", "image": "assets/images/hamburger.png", "description": "this is burger menu", "prix": 5, "isFavorite": false,"favorites":0},
    {"name": "Pizza", "image": "assets/images/pizza.png", "description": "this is pizzas menu", "prix": 8},
    //{"name": "Drinks", "image": "images/drinks.jpg", "description": "this is drinks menu", "prix": 3, "isFavorite": false},
    //{"name": "Salads", "image": "images/salads.jpg", "description": "this is salads menu", "prix": 4, "isFavorite": false},
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        items: [

        BottomNavigationBarItem(icon: Icon(Icons.home,color: successColor,),label: "home"),
        BottomNavigationBarItem(icon: Icon(Icons.event_note_outlined,color: successColor,),label: "orders"),
        BottomNavigationBarItem(icon: Icon(Icons.messenger,color: successColor,),label: "messege"),
        BottomNavigationBarItem(icon: Icon(Icons.person,color: successColor,),label: "account"),
      ],),
      key: scaffoldKey,

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(height: 10,),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child:  IconButton(
                          icon: const Icon(Icons.person),
                          onPressed: () {

                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // Add space between the image and the text
                    // Column for text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                      children: [
                        Text(
                          "Deliver to",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'Urbanist-SemiBold',
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Times Square", // Address
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist-SemiBold',
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down, // Add the arrow icon
                              size: 16,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.redAccent),
                onPressed: () {
                  // Action pour le bouton
                },
              ),
            ],
          ),
          Row(
            children: const [
              // Text("Welcome yahya "),

            ],
          ),

          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.green),
              ),
              prefixIcon: const Icon(Icons.search),
              hintText: "Search",
              border: InputBorder.none,
              fillColor: Colors.grey[200],
              filled: true,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Special Offers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize:30,
                    fontFamily: "Urbanist-medium"),
              ),
              Row(
                children: [
                  Text("See all",style: TextStyle(
                      fontSize:20,
                      color: successColor,
                      fontFamily: "Urbanist-medium"
                  ),),
                  Icon(Icons.navigate_next),
                ],
              ),
            ],
          ),
          Expanded(
            child: Image.asset(
              "assets/images/SpecialOffers.png",
              fit: BoxFit.contain, // or BoxFit.cover or BoxFit.fill depending on how you want it to behave
            ),
          ),
          Container(
            child: Wrap(
              spacing: 10.0,
              runSpacing: 4.0, // Espace vertical entre les lignes
              children: Menus.map((menu) {
                return GestureDetector(
                  onTap: () {
                    // Action à effectuer lors du tap sur un élément
                  },
                    child: InkWell(
                      onTap: (){
                        Get.to(MenuProducts(data:menu,));
                      },
                      child: Column(
                      children: [
                        Image.asset(
                          menu['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          menu['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                      ],
                    ),)
                );
              }).toList(),
            ),
          ),
          //const SizedBox(height: 10),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    "Recommended for you",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.sentiment_satisfied_alt,
                    size: 30,
                    color: Colors.green,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("See all"),
                  IconButton(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.navigate_next),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: Menus.map((menu) {
                return GestureDetector(
                  onTap: () {

                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(right: 10),
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.asset(
                                  menu['image'],
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (menu.containsKey('promo'))
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Text(
                                      'PROMO',
                                      style: TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Urbanist-medium"),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            menu['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16,fontFamily: "Urbanist-medium"),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey, size: 16),
                              Text(
                                "1.2 km", // Use actual data
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                    fontFamily: "Urbanist-medium"
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.star, color: Colors.orange, size: 16),
                              Text(
                                "4.5 (1.9k)",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                    fontFamily: "Urbanist-medium"
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [


                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.delivery_dining, size: 16,color: successColor),
                              const SizedBox(width: 4),
                              Text(
                                "\$${menu['prix'].toString()}",
                                style: const TextStyle(fontSize: 14,color: successColor,fontFamily: "Urbanist-medium"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),



        ],
      ),
    );
  }
}
