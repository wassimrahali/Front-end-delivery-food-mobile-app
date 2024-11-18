import 'package:flutter/material.dart';
import 'package:Foodu/utils/colors.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'DeliverymanOrders.dart';
import 'DeliverymanProfile.dart';
import 'HomeScreenDeliveryman.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions() {
    return [
      Homescreendeliveryman(),
      DeliverymanOrders(),
      DeliverymanProfile()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  final _controller03 = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Foodie Food", style: TextStyle(color: successColor, fontWeight: FontWeight.bold)),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AdvancedSwitch(
                activeColor: successColor,
                inactiveColor: Colors.red,
                activeChild: Text('Online'),
                inactiveChild: Text('Offline'),
                width: 80,
                controller: _controller03,
              ),
              SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: _widgetOptions()[_selectedIndex], // Display the selected screen
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: successColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex, // Ensure that the current index is set correctly
        onTap: _onItemTapped, // Update index on tap
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
