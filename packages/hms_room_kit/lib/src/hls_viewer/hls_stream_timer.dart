import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class HLSStreamTimer extends StatefulWidget {
  @override
  State<HLSStreamTimer> createState() => _HLSStreamTimerState();
}

class _HLSStreamTimerState extends State<HLSStreamTimer> {
  int _secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    DateTime? startedAt = context
        .read<MeetingStore>()
        .hmsRoom
        ?.hmshlsStreamingState
        ?.variants
        .first
        ?.startedAt;

    if (startedAt != null) {
      _secondsElapsed = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(
              startedAt.millisecondsSinceEpoch))
          .inSeconds;
    }
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

    ///We only show seconds if hours and minutes are 0
    ///only minutes if hours are 0
    ///only hours if hours are greater than 0
    return "Started${_hours > 0 ? " ${_hours.toString()}h" : ""} ${_hours < 1 && _minutes > 0 ? "${_minutes.toString()}m" : ""} ${_hours < 1 && _minutes < 1 ? "${_seconds.toString()}s " : ""}ago";
  }

  @override
  Widget build(BuildContext context) {
    return HMSSubtitleText(
        text: _getFormattedTime(),
        letterSpacing: 0.4,
        textColor: HMSThemeColors.onSurfaceMediumEmphasis);
  }
}
