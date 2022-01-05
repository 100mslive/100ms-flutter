// Project imports:
import 'package:hmssdk_flutter/src/enum/hms_log_level.dart';

class HMSLog {
  HMSLogLevel level;
  String tag;
  String message;
  bool isWebRtcLog;

  HMSLog(
      {required this.level,
      required this.tag,
      required this.message,
      required this.isWebRtcLog});

  factory HMSLog.fromMap(Map map) {
    map = map["log"];
    return HMSLog(
        level: HMSLogLevelValue.getHMSTrackKindFromName(map["level"]),
        tag: map["tag"],
        message: map["message"],
        isWebRtcLog: map["is_web_rtc_log"]);
  }

  Map<String, dynamic> toMap() => {
        'tag': tag,
        'message': message,
      };

  @override
  String toString() {
    return 'HMSLog{level: $level, tag: $tag, message: $message, isWebRtcLog: $isWebRtcLog}';
  }
}
