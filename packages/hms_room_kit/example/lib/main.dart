import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/hms_room_kit.dart';

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
      home: const MyHomePage(),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController meetingLinkController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/welcome.svg',
                width: width * 0.95,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text('Experience the power of 100ms',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        letterSpacing: 0.25,
                        color: themeDefaultColor,
                        height: 1.17,
                        fontSize: 34,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: Text('Try out the HMS Prebuilt SDK',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        letterSpacing: 0.5,
                        color: themeSubHeadingColor,
                        height: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
