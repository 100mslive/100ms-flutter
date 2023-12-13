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
  HMSRecordingState state;
  HMSServerRecordingState(
      {required this.error,
      required this.running,
      this.startedAt,
      required this.state});

  factory HMSServerRecordingState.fromMap(Map map) {
    return HMSServerRecordingState(
        error: map["error"] != null ? HMSException.fromMap(map) : null,
        running: map['running'],
        startedAt: map['started_at'] != null
            ? HMSDateExtension.convertDateFromEpoch(map['started_at'])
            : null,
        state: HMSRecordingStateValues.getRecordingStateFromName(
            map['state'] ?? 'NONE'));
  }
}
