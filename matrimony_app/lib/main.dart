import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimony_app/Screens/splashScreen.dart';  // Import the SplashScreen
import 'package:provider/provider.dart';
import 'Provider/userProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: SplashScreen(),  // Show SplashScreen first
      debugShowCheckedModeBanner: false,
    );
  }
}
