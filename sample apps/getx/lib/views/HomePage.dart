import 'dart:io';

import 'package:demo_with_getx_and_100ms/views/PreviewWidget.dart';
import 'package:demo_with_getx_and_100ms/views/RoomWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meetingTextController = TextEditingController(
        text: "https://shaik.app.100ms.live/meeting/ajk-stp-ebs");
    final nameTextController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/icons/hms_icon_1024.png"),
          title: const Text("100ms and Getx Demo App"),
          actions: [
            Image.asset("assets/icons/getx_logo.webp"),
          ],
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: meetingTextController,
                autofocus: true,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                    hintText: 'Enter Room URL',
                    suffixIcon: IconButton(
                      onPressed: meetingTextController.clear,
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
                  if (!(GetUtils.isBlank(meetingTextController.text) ?? true) &&
                      !(GetUtils.isBlank(nameTextController.text) ?? true)) {
                    if (kDebugMode) {
                      print(
                          "RaisedButton ${meetingTextController.text} ${nameTextController.text}");
                    }
                    bool res = await getPermissions();
                    if (res) {
                      Get.to(() => PreviewWidget(
                          meetingTextController.text, nameTextController.text));
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.video_call_outlined, size: 48),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Join Meeting',
                          style: TextStyle(height: 1, fontSize: 24))
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.camera.request();
    await Permission.microphone.request();

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
}
