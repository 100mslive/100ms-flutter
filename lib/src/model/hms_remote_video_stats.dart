import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSRemoteVideoStats {
	// Packet Jitter measured in seconds for this track. Calculated as defined in section 6.4.1. of RFC3550.
  double jitter;
	// Total bytes received by this track in the current session.
  int bytesReceived;
	// Incoming bitrate of this track observed since previous report in Kb/s.
	double bitrate;
	// Total packets received by this track in the current session.
  int packetsReceived;
	// Total packets lost by this track in the current session.
	int packetsLost;
	// Resolution of video frames being received.
	HMSVideoResolution resolution;
	// Frame rate of video frames being received (FPS).
	double frameRate;

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
