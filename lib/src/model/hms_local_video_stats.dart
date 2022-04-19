import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSLocalVideoStats {
  // Round trip time observed since previous report.
  double roundTripTime;
  // Total bytes sent by this track in the current session.
  int bytesSent;
  // Outgoing bitrate of this track observed since previous report in Kb/s.
  double bitrate;
  // Resolution of video frames being sent.
  double frameRate;
  // Frame rate of video frames being sent (FPS).
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
