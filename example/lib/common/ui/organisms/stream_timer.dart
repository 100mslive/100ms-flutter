import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_subtitle_text.dart';

class StreamTimer extends StatefulWidget {
  final DateTime startedAt;

  StreamTimer({required this.startedAt});
  @override
  State<StreamTimer> createState() => _StreamTimerState();
}

class _StreamTimerState extends State<StreamTimer> {
  format(Duration d) {
    String time = d.toString().split('.').first.padLeft(8, "0");
    if (time.substring(0, 2) == "00") {
      time = time.substring(3, time.length);
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        if (Platform.isIOS)
          return HLSSubtitleText(
              text: format(DateTime.now().toUtc().difference(
                  widget.startedAt.add(DateTime.now().timeZoneOffset))),
              textColor: subHeadingColor);
        return HLSSubtitleText(
            text: format(
                DateTime.now().toUtc().difference(widget.startedAt.toUtc())),
            textColor: subHeadingColor);
      },
    );
  }
}
