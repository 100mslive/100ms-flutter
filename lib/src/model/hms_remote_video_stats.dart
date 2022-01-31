import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSRemoteVideoStats {
  int bytesReceived;
  double bitrate;
  double jitter;
  int packetsReceived;
  int packetsLost;
  double frameRate;
  HMSVideoResolution resolution;

  HMSRemoteVideoStats(
      {required this.bytesReceived,
      required this.jitter,
      required this.bitrate,
      required this.packetsLost,
      required this.packetsReceived,
      required this.frameRate,
      required this.resolution});

  factory HMSRemoteVideoStats.fromMap(Map map) {
    return HMSRemoteVideoStats(
        bytesReceived: map["bytes_received"],
        jitter: map["jitter"],
        bitrate: map["bitrate"],
        packetsLost: map['packets_lost'],
        packetsReceived: map['packets_received'],
        frameRate: map["frame_rate"],
        resolution: HMSVideoResolution.fromMap(map['resolution']));
  }
}
