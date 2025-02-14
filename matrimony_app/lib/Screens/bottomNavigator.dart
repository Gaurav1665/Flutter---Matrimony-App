import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimony_app/Screens/aboutUs.dart';
import 'package:matrimony_app/Screens/addUser.dart';
import 'package:matrimony_app/Screens/favoriteUsers.dart';
import 'package:matrimony_app/Screens/searchUser.dart';
import 'package:matrimony_app/Screens/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootScreen extends StatefulWidget {
  int? userId;
  RootScreen({super.key, this.userId});

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
      AddUserScreen(userId: widget.userId,),
      const FavoriteUserScreen(),
      const AboutUsScreen()
    ];
    currentScreen = widget.userId!=null ? 1 : 0;
    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          title: Text(
            "MATRIFY",
            style: GoogleFonts.nunito(fontWeight: FontWeight.bold, letterSpacing: 3),
          ),
          actions: [
            IconButton(onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', false);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SplashScreen()),
              );
            }, icon: Icon(Icons.login))
          ],
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
