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
  TextStyle fontColor(){
    return GoogleFonts.roboto(color: Color(0xFF003366));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffF4F4F4),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Color(0xffF4F4F4),
            backgroundColor: Color(0xff003366),
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            side: BorderSide(color: Color(0xffB0B0B0), width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
        ),
        // #F2D0A1 (Blush Pink)
        textTheme: GoogleFonts.robotoTextTheme().copyWith(
          bodyLarge: fontColor(),
          bodyMedium: fontColor(),
          bodySmall: fontColor(),
          displayLarge: fontColor(),
          displayMedium: fontColor(),
          displaySmall: fontColor(),
          headlineLarge: fontColor(),
          headlineMedium: fontColor(),
          headlineSmall: fontColor(),
          labelLarge: fontColor(),
          labelMedium: fontColor(),
          labelSmall: fontColor(),
          titleLarge: fontColor(),
          titleMedium: fontColor(),
          titleSmall: fontColor(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff003366),
          foregroundColor: Color(0xffF4F4F4),
          elevation: 2,
          iconTheme: IconThemeData(
            color: Color(0xffB0B0B0)
          )
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
        ),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
