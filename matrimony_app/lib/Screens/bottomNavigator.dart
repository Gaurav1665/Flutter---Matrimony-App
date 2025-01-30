import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_app/Model/userModel.dart';
import 'package:matrimony_app/Screens/aboutUs.dart';
import 'package:matrimony_app/Screens/addUser.dart';
import 'package:matrimony_app/Screens/favoriteUsers.dart';
import 'package:matrimony_app/Screens/searchUser.dart';

class RootScreen extends StatefulWidget {
  UserModel? user;
  RootScreen({super.key, this.user});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<Widget> screen;
  int currentScreen=0;
  late PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screen = [
    const SearchUserScreen(),
    AddUserScreen(user: widget.user??null,),
    const FavoriteUserScreen(),
    const AboutUsScreen(),
    ];

    currentScreen = widget.user!=null ? 1 : 0;

    controller=PageController(initialPage: currentScreen);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(title: Text("Matrimonial App"),),
      body: PageView(
          controller:controller ,
          children:screen,
          physics: const NeverScrollableScrollPhysics(),
        ),
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: Duration(milliseconds: 300),
        items: <Widget>[
          Icon(Icons.search),
          Icon(Icons.add),
          Icon(Icons.favorite),
          Icon(Icons.person)
        ],
        onTap: (index) {
          setState(() {
              currentScreen=index;
            });
            controller.jumpToPage(currentScreen);
        },
        
      ),
    );
  }
}