import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_local_audio_track.dart';

class HMSLocalVideoStats {
  double roundTripTime;
  int bytesSent;
  double bitrate;
  double frameRate;
  HMSVideoResolution resolution;

  HMSLocalVideoStats({
    required this.roundTripTime,
    required this.bytesSent,
    required this.bitrate,
    required this.frameRate,
    required this.resolution,
  });

  factory HMSLocalVideoStats.fromMap(Map map) {
    return HMSLocalVideoStats(
        roundTripTime: map["round_trip_time"],
        bytesSent: map["bytes_sent"],
        bitrate: map["bitrate"],
        frameRate: map["frame_rate"],
        resolution: HMSVideoResolution.fromMap(map['resolution']));
  }
}
