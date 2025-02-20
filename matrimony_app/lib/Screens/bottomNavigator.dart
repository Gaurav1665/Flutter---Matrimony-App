import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "MATRIFY",
            style: GoogleFonts.nunito(fontWeight: FontWeight.bold, letterSpacing: 3, color: Color(0xffF5F5F5)),
          ),
          actions: [
            IconButton(onPressed: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Warning"),
                    content: Text("Are you sure you want to Logout?"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No")
                      ),
                      ElevatedButton(
                          onPressed: () async{
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('isLoggedIn', false);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => SplashScreen()),
                            );
                          },
                          child: Text("Yes")
                      ),
                    ],
                  );
                },
              );
            }, icon: Icon(Icons.login, color: Color(0xffF5F5F5),))
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
          backgroundColor: Color(0xffF4F4F4),
          buttonBackgroundColor: Color(0xff003366),
          color: Color(0xff003366),
          animationDuration: Duration(milliseconds: 400),
          index: currentScreen,
          items: <Widget>[
            Icon(Icons.search, color: Color(0xffF4F4F4)),
            Icon(Icons.add, color: Color(0xffF4F4F4)),
            Icon(Icons.favorite, color: Color(0xffF4F4F4)),
            Icon(Icons.info_outline, color: Color(0xffF4F4F4)),
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
