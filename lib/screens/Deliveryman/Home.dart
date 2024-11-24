import 'package:flutter/material.dart';
import 'package:Foodu/utils/colors.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/Livrerauth/SignInFormLivrer.dart';
import '../../utils/api_constants.dart';
import 'DeliverymanOrders.dart';
import 'DeliverymanProfile.dart';
import 'HomeScreenDeliveryman.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
      Homescreendeliveryman(id:widget.id),
      DeliverymanOrders(id:widget.id),
      DeliverymanProfile(userId:widget.id)
    ];
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }
  bool _isLoading = false;
  Future<void> logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String apiUrl = ApiConstants.LogoutDeliveryMan;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        _showSnackBar('No active session found!');
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
        Get.offAll(SignInFormLivrer());
        _showSnackBar('Successfully logged out');
      } else {
        _showSnackBar('Logout failed! Please try again.');
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  final _controller03 = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Foodie Food", style: TextStyle(color: successColor, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(successColor),
                ),
              )
                  : const Icon(Icons.logout),
            ),
            onPressed: _isLoading ? null : logout,
            splashRadius: 24,
          ),
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
