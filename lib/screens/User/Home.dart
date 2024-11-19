import 'package:Foodu/screens/User/ProfileScreen.dart';
import 'package:Foodu/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Cartscreen/Orderscreen.dart';
import 'HomeScreen.dart';

class Home extends StatefulWidget {
  final int id;

  const Home({Key? key, required this.id}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions() {
    return [
      Homescreen(userId: widget.id), // Correctly accessing the user ID
      Orderscreen(userId: widget.id,),
      UpdateUserScreen(userId: widget.id), // Passing user ID correctly
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: _widgetOptions()[_selectedIndex], // Display the selected screen
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: successColor,
        unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: true,
        currentIndex: _selectedIndex, // Current selected index
        onTap: _onItemTapped, // Handle tap on bottom navigation items
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: 'Profile'),
        ],
        selectedLabelStyle: TextStyle(fontFamily: "Urbanist-Bold"),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}

// Orders screen widget

