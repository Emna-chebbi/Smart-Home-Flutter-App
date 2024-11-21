import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6B6FAA),
              Color(0xFF9898C8),
              Color(0xFF1191BF),
              Color(0xFF055375),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center all vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center all horizontally
          children: [
            // Title with custom font, bold
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Welcome to Your \n Smart Space!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SourGummy_Expanded-Bold', // Custom font
                  fontSize: 28,
                  fontWeight: FontWeight.bold, // Bold font
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
            // Space between title and image
            SizedBox(height: 20),
            // Centered image that fills the screen width properly
            Center(
              child: Image.asset(
                'assets/splash_screen.png',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width, // Fill the width
                height: MediaQuery.of(context).size.height * 0.4, // Adjusted height
              ),
            ),
            // Centered "Get Started" button
            Padding(
              padding: const EdgeInsets.only(top: 30.0), // Adjusted padding
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/sign_in');
                },
                label: Text(
                  "Get Started",
                  style: TextStyle(
                    fontFamily: 'SourGummy', // Custom font
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: TextStyle(
                    fontFamily: 'SourGummy', // Custom font
                    fontSize: 20,
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
