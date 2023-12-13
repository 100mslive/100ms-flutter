// Project imports:
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';
import 'package:hmssdk_flutter/src/enum/hms_recording_state.dart';

///100ms HMSHLSRecordingState
///
///[HMSHLSRecordingState] contains information about the hls recording status.
class HMSHLSRecordingState {
  final HMSException? error;
  final bool running;
  DateTime? startedAt;
  HMSRecordingState state;
  HMSHLSRecordingState(
      {required this.error,
      required this.running,
      this.startedAt,
      required this.state});

  factory HMSHLSRecordingState.fromMap(Map map) {
    return HMSHLSRecordingState(
        error: (map.containsKey('error') && map['error'] != null)
            ? HMSException.fromMap(map)
            : null,
        running: map['running'],
        startedAt: map['started_at'] != null
            ? HMSDateExtension.convertDateFromEpoch(map['started_at'])
            : null,
        state: HMSRecordingStateValues.getRecordingStateFromName(
            map['state'] ?? 'NONE'));
  }
}
