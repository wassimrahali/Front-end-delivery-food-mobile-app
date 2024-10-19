import 'package:Foodu/screens/HomeScreen.dart';
import 'package:Foodu/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/Userauth/SignInForm.dart';
import 'screens/Home.dart';
import 'screens/WelcomeScreens.dart';
import 'auth/Userauth/SignUpForm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get SharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if it's the first time the app is launched
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  // Check if a valid token is stored (user is logged in)
  String? token = prefs.getString('token');

  runApp(MyApp(isFirstTime: isFirstTime, token: token));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final String? token; // Token to check if user is logged in

  const MyApp({super.key, required this.isFirstTime, required this.token});

  @override
  //*****Not Workk (Save Data)
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.blue.withOpacity(0.3),
          cursorColor: successColor,
          selectionHandleColor: successColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: isFirstTime
          ? WelcomeScreens() // Show Welcome/Onboarding screen
          : (token != null && token!.isNotEmpty)
          ? Homescreen(userId: 2)
          : SignInForm(), // If no token, show SignIn page
    );
  }
}

