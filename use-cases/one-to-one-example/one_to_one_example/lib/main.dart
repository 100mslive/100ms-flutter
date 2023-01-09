import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_to_one_example/meeting/meeting_page.dart';
import 'package:one_to_one_example/utilities.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Color.fromRGBO(20, 23, 28, 1), elevation: 5),
          brightness: Brightness.dark,
          primaryColor: const Color.fromRGBO(36, 113, 237, 1),
          backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(36, 113, 237, 1)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ))))),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool res = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text('Experience the power of 100ms',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.17,
                    fontSize: 34,
                  )),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () async => {
                res = await Utilities.getPermissions(),
                if (res)
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (_) =>const  MeetingPage()))
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Text(
                  'Join',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 40,),
            const Text("One to one mode example",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),)
          ],
        ),
      ),
    );
  }
}
