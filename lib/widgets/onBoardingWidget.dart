import 'package:Foodu/screens/login.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String text;
  final String description;
  final int pageIndex;
  final PageController pageController;

  const OnboardingPage({
    Key? key,
    required this.image,
    required this.text,
    required this.description,
    required this.pageIndex,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 500, fit: BoxFit.cover),
          const SizedBox(height: 20),
          Text(
            text,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: successColor,
              fontFamily: 'Urbanist-SemiBold',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontFamily: 'Urbanist-Regular',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              if (pageIndex == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
                print("Get Started");
              } else {
                // Navigate to the next page
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Container(
                constraints: BoxConstraints(minWidth: 200, minHeight: 56),
                alignment: Alignment.center,
                child: Text(
                  pageIndex == 2 ? 'Get Started' : 'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
