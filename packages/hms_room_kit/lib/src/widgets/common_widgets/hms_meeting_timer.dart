import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:provider/provider.dart';

class HMSMeetingTimer extends StatefulWidget {
  @override
  State<HMSMeetingTimer> createState() => _HMSMeetingTimerState();
}

class _HMSMeetingTimerState extends State<HMSMeetingTimer> {
  int _secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsElapsed = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(
            context.read<MeetingStore>().hmsRoom?.startedAt ??
                DateTime.now().millisecondsSinceEpoch))
        .inSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  ///[_getFormattedTime] returns the formatted time in hh:mm:ss format
  String _getFormattedTime() {
    int _minutes = _secondsElapsed ~/ 60;
    int _seconds = _secondsElapsed % 60;
    int _hours = 0;
    if (_minutes > 59) {
      _hours = _minutes ~/ 60;
      _minutes %= 60;
    }

    return "${_hours > 0 ? "${_hours.toString().padLeft(2, '0')}:" : ""}${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return HMSSubheadingText(
        text: _getFormattedTime(),
        textColor: HMSThemeColors.onSurfaceHighEmphasis);
  }
}
