import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:mobx_example/meeting.dart';
import 'package:mobx_example/setup/hms_sdk_interactor.dart';
import 'package:mobx_example/setup/meeting_store.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
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
          colorScheme: ColorScheme.dark(
            primary: Colors.blue.shade700,
          )),
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

  TextEditingController nameTextController = TextEditingController(text: "");
  TextEditingController roomCode = TextEditingController(text: "zhr-seow-tuj");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "100ms Mobx Example",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: roomCode,
                autofocus: true,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                    hintText: 'Enter Room URL',
                    suffixIcon: IconButton(
                      onPressed: roomCode.clear,
                      icon: const Icon(Icons.clear),
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)))),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: nameTextController,
                autofocus: true,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                    hintText: 'Enter Name',
                    suffixIcon: IconButton(
                      onPressed: nameTextController.clear,
                      icon: const Icon(Icons.clear),
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)))),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: 300.0,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ))),
                onPressed: () async {
                  if (roomCode.text.isNotEmpty &&
                      nameTextController.text.isNotEmpty) {
                    bool res = await getPermissions();
                    if (res) {
                      HMSSDK hmssdk = HMSSDK();
                      await hmssdk.build();
                      var _hmssdkInteractor = HMSSDKInteractor(hmssdk: hmssdk);
                      var _meetingStore =
                          MeetingStore(hmssdkInteractor: _hmssdkInteractor);
                      _meetingStore.addUpdateListener();
                      bool ans = await _meetingStore.join(
                          nameTextController.text, roomCode.text);
                      if (!ans) {
                        const SnackBar(content: Text("Unable to Join"));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Meeting(
                                      meetingStore: _meetingStore,
                                    )));
                      }
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: const Text('Join Meeting',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
