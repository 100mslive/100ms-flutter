//Package imports
import 'package:flutter/material.dart';

//File imports
import 'package:google_meet/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Meet',
      theme: ThemeData(
          primaryColor: Colors.grey[900],
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.blueAccent),
                  foregroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.white)))),
      home: const HomeScreen(),
    );
  }
}
