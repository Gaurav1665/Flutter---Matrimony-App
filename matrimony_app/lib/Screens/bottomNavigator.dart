import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_app/Screens/aboutUs.dart';
import 'package:matrimony_app/Screens/addUser.dart';
import 'package:matrimony_app/Screens/favoriteUsers.dart';
import 'package:matrimony_app/Screens/searchUser.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  List<Widget> screens = [SearchUser(),AddUserScreen(),FavoriteUsers(),AboutUs()];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(title: Text("Matrimonial App"),),
      body: screens[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: Duration(milliseconds: 300),
        items: <Widget>[
          Icon(Icons.search, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.favorite, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}