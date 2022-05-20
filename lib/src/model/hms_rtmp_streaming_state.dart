// Project imports:
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';

///100ms HMSRtmlStreamingState
///
///[HMSRtmpStreamingState] contains information about the rtmp streaming status.
class HMSRtmpStreamingState {
  final HMSException? error;
  final bool running;
  DateTime? startedAt;
  HMSRtmpStreamingState(
      {required this.error, required this.running, this.startedAt});

  factory HMSRtmpStreamingState.fromMap(Map map) {
    return HMSRtmpStreamingState(
        error: map["error"] != null ? HMSException.fromMap(map) : null,
        running: map['running'],
        startedAt: map['started_at'] != null
            ? HMSDateExtension.convertDate(map['started_at'])
            : null);
  }
}
