import 'package:Foodu/auth/Userauth/VerifyResetCodePage.dart';
import 'package:Foodu/screens/User/Home.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/Userauth/SignInForm.dart';
import 'models/Card.model.dart';
import 'screens/OnBoarding/WelcomeScreens.dart';
import 'utils/api_constants.dart'; // Make sure to import your API constants

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get SharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if it's the first time the app is launched
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  // Check if a valid token is stored (user is logged in)
  String? token = prefs.getString('token');
  int? userId = prefs.getInt('userId'); // Retrieve user ID from SharedPreferences

  runApp(ChangeNotifierProvider(
    create: (context) => CartProvider(),
    child: MyApp(isFirstTime: isFirstTime, token: token, userId: userId),
  ),);
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final String? token;
  final int? userId; // Add userId to MyApp

  const MyApp({Key? key, required this.isFirstTime, required this.token, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3:true,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.blue.withOpacity(0.2),
          cursorColor: Colors.green,
          selectionHandleColor: Colors.green,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Foodie Food',
      home:isFirstTime
          ? WelcomeScreens() // Show Welcome/Onboarding screen
          : (token != null && token!.isNotEmpty && userId != null)
          ? Home(id: userId!) // Use the retrieved user ID
          : SignInForm(),
    );
  }
}
