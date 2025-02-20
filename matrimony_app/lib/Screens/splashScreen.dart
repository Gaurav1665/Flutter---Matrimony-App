import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matrimony_app/Screens/bottomNavigator.dart';
import 'package:matrimony_app/Screens/login.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 1), () async {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RootScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/images/logo.png',
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Color(0xff003366),
            ),
          ],
        ),
      ),
    );
  }
}
