import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late List<Widget> screen;
  int currentScreen = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    screen = [
      const SearchUserScreen(),
      AddUserScreen(), // Keep this as a separate screen for the PageView
      const FavoriteUserScreen(),
      const AboutUsScreen(),
    ];
    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          title: Text(
            "MATRIFY",
            style: GoogleFonts.nunito(fontWeight: FontWeight.bold, letterSpacing: 3),
          ),
          automaticallyImplyLeading: false,
        ),
        resizeToAvoidBottomInset: true,
        body: PageView(
          controller: controller,
          children: screen,
          physics: const NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: Duration(milliseconds: 300),
          index: currentScreen,
          items: <Widget>[
            Icon(Icons.search),
            Icon(Icons.add),
            Icon(Icons.favorite),
            Icon(CupertinoIcons.exclamationmark),
          ],
          onTap: (index) {
            setState(() {
              currentScreen = index;
            });
            controller.jumpToPage(currentScreen);
          },
        ),
      ),
    );
  }
}
