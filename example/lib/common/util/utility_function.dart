//Package imports
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:permission_handler/permission_handler.dart';

class Utilities {
  static String getAvatarTitle(String name) {
    List<String>? parts = name.trim().split(" ");
    if (parts.length == 1) {
      name = parts[0][0];
    } else if (parts.length >= 2) {
      name = parts[0][0];
      if (parts[1] == "" || parts[1] == " ") {
        name += parts[0][1];
      } else {
        name += parts[1][0];
      }
    }
    return name.toUpperCase();
  }

  static Color getBackgroundColour(String name) {
    return Utilities
        .colors[name.toUpperCase().codeUnitAt(0) % Utilities.colors.length];
  }

  static List<Color> colors = [
    Color(0xFFFAC919),
    Color(0xFF00AE63),
    Color(0xFF6554C0),
    Color(0xFFF69133),
    Color(0xFF8FF5FB)
  ];

  static double getRatio(Size size, BuildContext context) {
    EdgeInsets viewPadding = MediaQuery.of(context).viewPadding;
    return (size.height -
            viewPadding.top -
            viewPadding.bottom -
            kToolbarHeight) /
        (size.width - viewPadding.left - viewPadding.right);
  }

  static void setRTMPUrl(String roomUrl) {
    List<String> urlSplit = roomUrl.split('/');
    int index = urlSplit.lastIndexOf("meeting");
    if (index != -1) {
      urlSplit[index] = "preview";
    }
    Constant.rtmpUrl = urlSplit.join('/') + "?token=beam_recording";
  }

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

  static Future<bool> getCameraPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.camera.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }

    return true;
  }

  static MeetingFlow deriveFlow(String roomUrl) {
    final joinFlowRegex = RegExp("\.100ms\.live\/(preview|meeting)\/");
    final hlsFlowRegex = RegExp("\.100ms\.live\/hls-streaming\/");

    if (joinFlowRegex.hasMatch(roomUrl)) {
      return MeetingFlow.join;
    } else if (hlsFlowRegex.hasMatch(roomUrl)) {
      return MeetingFlow.hlsStreaming;
    } else {
      return MeetingFlow.none;
    }
  }

  static void showToast(String message) {
    Fluttertoast.showToast(msg: message, backgroundColor: Colors.black87);
  }
}
