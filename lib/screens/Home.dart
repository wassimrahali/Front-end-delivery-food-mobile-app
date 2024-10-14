//Layout Hathi ******************************************************************!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//*****************Nbadloulha esmha b3d wil componnet n7othom wa7dhom
//**************bch tal89a fiha Navigayion of bootom bar

import 'package:flutter/material.dart';

import 'HomeScreen.dart';

void main() {
  runApp(const MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  // List of widget options for each tab
  final List<Widget> _widgetOptions = [
    Homescreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions[_selectedIndex], // Display the selected screen
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: true,
        currentIndex: _selectedIndex, // Current selected index
        onTap: _onItemTapped, // Handle tap on bottom navigation items
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: 'Profile'),
        ],
        selectedLabelStyle: TextStyle(fontFamily: "Urbanist-Bold"),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}



// Orders screen widget
class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Orders Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Profile screen widget
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
