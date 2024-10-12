import 'package:flutter/material.dart';
import 'package:Foodu/utils/colors.dart';
class WelcomeScreens extends StatelessWidget {
  const WelcomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset('assets/images/bg1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          Center(
            child: Column(
              mainAxisAlignment:MainAxisAlignment.end,
              children: [
                SafeArea(
                      child:Column(
                        children: [
                          Text("Welcome to\n Foodu ! 👋",
                              style:TextStyle(
                                  color: successColor,
                                  fontSize: 40,
                                  fontFamily:'Urbanist-Bold',
                              ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                            child: Center(child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                              style: TextStyle(color: Colors.white,fontSize: 14,
                              fontFamily: "Urbanist-Regular"),
                              textAlign:TextAlign.center,)
                            ),
                          )
                        ],
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
