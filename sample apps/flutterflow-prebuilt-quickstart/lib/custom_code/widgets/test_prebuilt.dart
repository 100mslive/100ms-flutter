// Automatic FlutterFlow imports
// Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:hms_room_kit/hms_room_kit.dart';

class TestPrebuilt extends StatefulWidget {
  const TestPrebuilt({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  _TestPrebuiltState createState() => _TestPrebuiltState();
}

class _TestPrebuiltState extends State<TestPrebuilt> {
  @override
  Widget build(BuildContext context) {
    return const HMSPrebuilt(roomCode: "xno-jwn-phi");
  }
}
