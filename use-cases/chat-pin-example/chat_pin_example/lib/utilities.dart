import 'dart:io';

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Utilities {
  static Future<bool> getPermissions() async {
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

  static HMSConfig getHMSConfig() {
    String authToken =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiNjIxOGEyMzk2OTJiNmQwNTIzMDlmNGY2Iiwicm9vbV9pZCI6IjYyMThhMjdlN2E5ZDA0ZTI4YzYwYzEwZiIsInVzZXJfaWQiOiJ3YWdvdXVwZyIsInJvbGUiOiJob3N0IiwianRpIjoiZDYxNzI2MWItYjc0Ny00YmE2LWFmYjctMmQzNzNlZmRiNzQwIiwidHlwZSI6ImFwcCIsInZlcnNpb24iOjIsImV4cCI6MTY3MzMzNzY5OH0.gs-xpJyi17wcWYdavsg9w4Yc5aZ5rCl-lAKIDcY-30g";
    return HMSConfig(authToken: authToken, userName: "test_username");
  }
}
