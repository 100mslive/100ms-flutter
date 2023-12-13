// Project imports:
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';
import 'package:hmssdk_flutter/src/enum/hms_streaming_state.dart';

///100ms HMSRtmpStreamingState
///
///[HMSRtmpStreamingState] contains information about the rtmp streaming status.
class HMSRtmpStreamingState {
  final HMSException? error;
  final bool running;
  DateTime? startedAt;
  HMSStreamingState state;
  HMSRtmpStreamingState(
      {required this.error,
      required this.running,
      this.startedAt,
      required this.state});

  factory HMSRtmpStreamingState.fromMap(Map map) {
    return HMSRtmpStreamingState(
        error: map["error"] != null ? HMSException.fromMap(map) : null,
        running: map['running'],
        startedAt: map['started_at'] != null
            ? HMSDateExtension.convertDateFromEpoch(map['started_at'])
            : null,
        state: HMSStreamingStateValues.getStreamingStateFromName(
            map['state'] ?? 'NONE'));
  }
}
