import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
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
    //Temporary authToken can be found on dashboard.
    //To know how to get temporary token, check here: https://www.100ms.live/docs/flutter/v2/guides/token
    String authToken =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3Nfa2V5IjoiNjE4YjU1OTBiZTZjM2MwYjM1MTUwYWJhIiwicm9vbV9pZCI6IjYxOGI1NWQ4YmU2YzNjMGIzNTE1MGFiZCIsInVzZXJfaWQiOiJiYTY3NmRiYi0wMjI0LTRlYTMtYjFlMi0zNmMxYjczMjI0ZjQiLCJyb2xlIjoiaG9zdCIsImp0aSI6IjZkYTgwMmEzLTRkNjItNDQyYy04MTdkLTU1ZWI1YWJlYmUyOCIsInR5cGUiOiJhcHAiLCJ2ZXJzaW9uIjoyLCJleHAiOjE2NzM2MTg1Mzd9.3TkXrmp-PA1gu2_tsjsJ_pA0tJNZnlOA8vIMv-iajU0";
    return HMSConfig(authToken: authToken, userName: "test_username");
  }

  static showToast({required String msg}) {
    Fluttertoast.showToast(msg: msg, timeInSecForIosWeb: 3);
  }
}
