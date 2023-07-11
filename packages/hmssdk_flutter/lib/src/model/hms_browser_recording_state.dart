// Project imports:
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';

///100ms HMSBrowserRecordingState
///
///[HMSBrowserRecordingState] contains information about the borwser recording status.
class HMSBrowserRecordingState {
  final HMSException? error;
  final bool running;
  DateTime? startedAt;
  HMSBrowserRecordingState(
      {required this.error, required this.running, this.startedAt});

  factory HMSBrowserRecordingState.fromMap(Map map) {
    return HMSBrowserRecordingState(
        error: map["error"] != null ? HMSException.fromMap(map) : null,
        running: map['running'],
        startedAt: map['started_at'] != null
            ? HMSDateExtension.convertDate(map['started_at'])
            : null);
  }
}
