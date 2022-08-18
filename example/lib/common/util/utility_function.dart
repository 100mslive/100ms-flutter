//Package imports
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utilities {
  static RegExp REGEX_EMOJI = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  static String getAvatarTitle(String name) {
    if (name.contains(REGEX_EMOJI)) {
      name = name.replaceAll(REGEX_EMOJI, '');
      if (name.trim().isEmpty) {
        return '😄';
      }
    }
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
    if (name.contains(REGEX_EMOJI)) {
      name = name.replaceAll(REGEX_EMOJI, '');
      if (name.trim().isEmpty) {
        return Color(0xFF6554C0);
      }
    }
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
            kToolbarHeight -
            kBottomNavigationBarHeight -
            4) /
        (size.width);
  }

  static double getHLSRatio(Size size, BuildContext context) {
    return (size.height) / (size.width);
  }

  static void setRTMPUrl(String roomUrl) {
    if (roomUrl.contains("flutterhms.page.link") &&
        roomUrl.contains("meetingUrl")) {
      roomUrl = roomUrl.split("meetingUrl=")[1];
    }
    List<String> urlSplit = roomUrl.split('/');
    int index = urlSplit.lastIndexOf("meeting");
    if (index != -1) {
      urlSplit[index] = "preview";
    }
    Constant.streamingUrl = urlSplit.join('/') + "?skip_preview=true";
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
    final hlsFlowRegex = RegExp("\.100ms\.live\/streaming\/");

    if (joinFlowRegex.hasMatch(roomUrl)) {
      return MeetingFlow.meeting;
    } else if (hlsFlowRegex.hasMatch(roomUrl)) {
      return MeetingFlow.hlsStreaming;
    } else {
      return MeetingFlow.none;
    }
  }

  static void showToast(String message, {int time = 1}) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black87,
        timeInSecForIosWeb: time);
  }

  static Future<String> getStringData({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? "";
  }

  static void saveStringData(
      {required String key, required String value}) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key, value);
  }

  static Future<int> getIntData({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key) ?? 0;
  }

  static void saveIntData({required String key, required int value}) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt(key, value);
  }

  static String fetchMeetingLinkFromFirebase(String url) {
    url = url.split("deep_link_id=")[1];
    url = url.split("&")[0];
    url = url.replaceAll("%3A", ":").replaceAll("%2F", "/");
    return url;
  }
}
