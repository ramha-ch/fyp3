import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:projectchashmart/View/LoginPage.dart';
import 'package:projectchashmart/View/SignUpPage.dart';

class welcomeScreen extends StatelessWidget {
  const welcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF183765),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            SizedBox(height: 140),

            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 , ),
                child: Image.asset(
                  'assets/View/logo.jpg',
                  width: 300,
                  height: 300,
                ),
              ),
            ),

            SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,

                fixedSize: Size(200, 50),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF183765),
                fixedSize: Size(200, 50),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }
}