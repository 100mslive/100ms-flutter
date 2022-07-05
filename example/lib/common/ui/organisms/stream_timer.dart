import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class StreamTimer extends StatefulWidget {
  final DateTime startedAt;

  StreamTimer({required this.startedAt});
  @override
  State<StreamTimer> createState() => _StreamTimerState();
}

class _StreamTimerState extends State<StreamTimer> {
  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Text(
          format(DateTime.now().toUtc().difference(widget.startedAt.toUtc())),
          style: GoogleFonts.inter(
              fontSize: 12,
              color: subHeadingColor,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w400),
        );
      },
    );
  }
}
