// Project imports:
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';
import 'package:hmssdk_flutter/src/enum/hms_recording_state.dart';

///100ms HMSBrowserRecordingState
///
///[HMSBrowserRecordingState] contains information about the browser recording status.
class HMSBrowserRecordingState {
  final HMSException? error;
  final bool running;
  DateTime? startedAt;
  final bool initialising;
  HMSRecordingState state;
  HMSBrowserRecordingState(
      {required this.error,
      required this.running,
      this.startedAt,
      required this.initialising,
      required this.state});

  factory HMSBrowserRecordingState.fromMap(Map map) {
    return HMSBrowserRecordingState(
        error: map["error"] != null ? HMSException.fromMap(map) : null,
        running: map['running'],
        startedAt: map['started_at'] != null
            ? HMSDateExtension.convertDateFromEpoch(map['started_at'])
            : null,
        initialising: map['initialising'],
        state: HMSRecordingStateValues.getRecordingStateFromName(
            map['state'] ?? 'NONE'));
  }
}
