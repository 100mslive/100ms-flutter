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
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiNjE4YjU1OTBiZTZjM2MwYjM1MTUwYWJhIiwicm9vbV9pZCI6IjYxOGI1NWQ4YmU2YzNjMGIzNTE1MGFiZCIsInVzZXJfaWQiOiI1Njc0N2U4ZC01ZGIyLTRkZDEtYmEyNC1iYjQzNzRhNmVhMGQiLCJyb2xlIjoiaG9zdCIsImp0aSI6IjNiOTk2ZDE4LTc5ZmQtNGI4ZS05Yzg0LTk3M2U5OTc5NDA4MyIsInR5cGUiOiJhcHAiLCJ2ZXJzaW9uIjoyLCJleHAiOjE2NzMyNzM3ODd9.H1nYAiFgMOkxGADANUHrjZB3aUVXlSfSi5_SRk6zQfc";
    return HMSConfig(authToken: authToken, userName: "test_username");
  }
}
