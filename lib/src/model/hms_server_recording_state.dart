// Project imports:
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';

import '../../hmssdk_flutter.dart';

///100ms HMSServerRecordingState
///
///[HMSServerRecordingState] contains information about the server recording status.
class HMSServerRecordingState {
  final HMSException? error;
  final bool running;
  DateTime? startedAt;
  HMSServerRecordingState(
      {required this.error, required this.running, this.startedAt});

  factory HMSServerRecordingState.fromMap(Map map) {
    return HMSServerRecordingState(
        error: map["error"] != null ? HMSException.fromMap(map) : null,
        running: map['running'],
        startedAt: map['started_at'] != null
            ? HMSDateExtension.convertDate(map['started_at'])
            : null);
  }
}
