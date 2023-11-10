import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:sample_application/presentation/features/home/home_main_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeMainView(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: themeBottomSheetColor, elevation: 5),
          brightness: Brightness.dark,
          primaryColor: const Color.fromARGB(255, 13, 107, 184),
          scaffoldBackgroundColor: Colors.black),
    );
  }
}
