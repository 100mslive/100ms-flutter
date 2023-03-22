///100ms HMSLocalAudioStats
///
/// [HMSLocalAudioStats] contains the stats for local peer audio stats.
class HMSLocalAudioStats {
  /// Round trip time observed since previous report.
  double roundTripTime;

  /// Total bytes sent by this track in the current session.
  int bytesSent;

  /// Outgoing bitrate of this track observed since previous report in Kb/s.
  double bitrate;

  HMSLocalAudioStats({
    required this.roundTripTime,
    required this.bytesSent,
    required this.bitrate,
  });

  factory HMSLocalAudioStats.fromMap(Map map) {
    return HMSLocalAudioStats(
      roundTripTime: map["round_trip_time"] ?? 0.0,
      bytesSent: map["bytes_sent"] ?? 0,
      bitrate: map["bitrate"] ?? 0.0,
    );
  }
}
