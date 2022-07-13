///100ms HMSRTCStats
///
///[HMSRTCStats] containes bytesSent, bytesReceived, packetReceived,packetsLost, bitrateSent, bitrateReceived and roundTripTime.
class HMSRTCStats {
  /// Total bytes sent in the current session.
  int bytesSent;

  /// Total bytes received in the current session.
  int bytesReceived;

  /// Total packets received in the current session.
  int packetsReceived;

  /// Total packets lost in the current session.
  int packetsLost;

  /// Total outgoing bitrate observed since previous report.
  double bitrateSent;

  /// Total incoming bitrate observed since previous report in Kb/s.
  double bitrateReceived;

  /// Average round trip time observed since previous report in Kb/s.
  double roundTripTime;

  HMSRTCStats(
      {required this.bytesSent,
      required this.bytesReceived,
      required this.packetsReceived,
      required this.packetsLost,
      required this.bitrateReceived,
      required this.bitrateSent,
      required this.roundTripTime});

  factory HMSRTCStats.fromMap(Map map) {
    return HMSRTCStats(
        bytesSent: map["bytes_sent"],
        bytesReceived: map["bytes_received"],
        packetsReceived: map["packets_received"],
        packetsLost: map["packets_lost"],
        bitrateReceived: map["bitrate_received"],
        bitrateSent: map["bitrate_sent"],
        roundTripTime: map["round_trip_time"]);
  }
}

///[HMSRTCStatsReport] contains stats for [HMSroom].
class HMSRTCStatsReport {
  // Combined audio + video values
  HMSRTCStats combined;
  // Summary of all audio tracks
  HMSRTCStats audio;
  // Summary of all video tracks
  HMSRTCStats video;

  HMSRTCStatsReport(
      {required this.combined, required this.audio, required this.video});

  factory HMSRTCStatsReport.fromMap(Map map) {
    return HMSRTCStatsReport(
      combined: HMSRTCStats.fromMap(map["combined"]),
      audio: HMSRTCStats.fromMap(map["audio"]),
      video: HMSRTCStats.fromMap(map["video"]),
    );
  }
}
