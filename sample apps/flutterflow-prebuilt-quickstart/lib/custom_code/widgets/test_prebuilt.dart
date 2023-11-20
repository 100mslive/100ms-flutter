// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:hms_room_kit/hms_room_kit.dart';

class TestPrebuilt extends StatefulWidget {
  const TestPrebuilt({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _TestPrebuiltState createState() => _TestPrebuiltState();
}

class _TestPrebuiltState extends State<TestPrebuilt> {
  @override
  Widget build(BuildContext context) {
    return HMSPrebuilt(roomCode: "xno-jwn-phi");
  }
}
