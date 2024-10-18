import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/Home.dart';
import 'screens/WelcomeScreens.dart';
import 'auth/SignUpForm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get SharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if it's the first time the app is launched
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  // Check if user is signed in
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isFirstTime: isFirstTime, isLoggedIn: isLoggedIn));

}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final bool isLoggedIn;
  final int? userId;

  const MyApp({super.key, required this.isFirstTime, required this.isLoggedIn, this.userId});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: isFirstTime
          ? WelcomeScreens() // If it's the first time, show Welcome/Onboarding
          : isLoggedIn
          ?Home(id: userId!) // If user is logged in, show Home
          : SignUpForm(), // If not logged in, show SignUp page
    );
  }
}
