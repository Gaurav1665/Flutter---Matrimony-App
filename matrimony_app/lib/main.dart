import 'package:flutter/material.dart';
import 'package:matrimony_app/Screens/bottomNavigator.dart';
import 'Provider/userProvider.dart';
import 'package:provider/provider.dart';

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
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}