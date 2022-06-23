import 'dart:io';

import 'package:example_riverpod/preview/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '100ms mobx',
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

Future<bool> getPermissions() async {
  if (Platform.isIOS) return true;
  await Permission.camera.request();
  await Permission.microphone.request();
  await Permission.bluetoothConnect.request();

  while ((await Permission.camera.isDenied)) {
    await Permission.camera.request();
  }
  while ((await Permission.microphone.isDenied)) {
    await Permission.microphone.request();
  }
  while ((await Permission.bluetoothConnect.isDenied)) {
    await Permission.bluetoothConnect.request();
  }
  return true;
}

class _HomePageState extends State<HomePage> {
  TextEditingController txtName = TextEditingController(text: "");
  TextEditingController txtId = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("mobx Clone"),
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
            "Enter Link",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: txtId,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Enter Room Link'),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                if (await getPermissions()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreviewScreen(
                              name: txtName.text,
                              roomLink: txtId.text,
                            )),
                  );
                }
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
