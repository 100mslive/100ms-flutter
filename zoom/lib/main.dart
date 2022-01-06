import 'package:flutter/material.dart';
import 'package:zoom/meeting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '100ms Zoom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txtName =
      TextEditingController(text: "Govind Maheshwari");
  TextEditingController txtId = TextEditingController(
      text: "https://clubhouse1.app.100ms.live/meeting/wce-kmi-jce");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zoom Clone"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Name",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: 'Enter Your Name'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Enter Id",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: txtId,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Enter Room Id'),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Meeting(
                            name: txtName.text,
                            roomLink: txtId.text,
                          )),
                );
              },
              child: const Text(
                "Join",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }
}
