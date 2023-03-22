import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSLocalVideoStats
///
/// [HMSLocalVideoStats] contains the stats for local peer video stats.
class HMSLocalVideoStats {
  /// Round trip time observed since previous report.
  double roundTripTime;

  /// Total bytes sent by this track in the current session.
  int bytesSent;

  /// Outgoing bitrate of this track observed since previous report in Kb/s.
  double bitrate;

  /// Resolution of video frames being sent.
  double frameRate;

  /// Frame rate of video frames being sent (FPS).
  HMSResolution resolution;

  ///Reason for quality limitations
  HMSQualityLimitationReasons? hmsQualityLimitationReasons;

  ///Simulcast Layer
  HMSSimulcastLayer? hmsLayer;

  HMSLocalVideoStats(
      {required this.roundTripTime,
      required this.bytesSent,
      required this.bitrate,
      required this.frameRate,
      required this.resolution,
      required this.hmsQualityLimitationReasons,
      required this.hmsLayer});

  factory HMSLocalVideoStats.fromMap(Map map) {
    return HMSLocalVideoStats(
        roundTripTime: map["round_trip_time"] ?? 0.00,
        bytesSent: map["bytes_sent"] ?? 0,
        bitrate: map["bitrate"] ?? 0.00,
        frameRate: map["frame_rate"] ?? 0.0,
        resolution: map['resolution'] == null
            ? HMSResolution(height: 0, width: 0)
            : HMSResolution.fromMap(map['resolution']),
        hmsQualityLimitationReasons:
            map.containsKey("quality_limitation_reason")
                ? HMSQualityLimitationReasons.fromMap(
                    map["quality_limitation_reason"])
                : null,
        hmsLayer: map.containsKey("hms_layer")
            ? HMSSimulcastLayerValue.getHMSSimulcastLayerFromName(
                map["hms_layer"])
            : null);
  }
}
