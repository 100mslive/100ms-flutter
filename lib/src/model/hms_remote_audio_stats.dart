///100ms HMSRemoteAudioStats
///
/// [HMSRemoteAudioStats] contains the stats for remote peer audio stats.
class HMSRemoteAudioStats {
  /// Packet Jitter measured in seconds for this track. Calculated as defined in section 6.4.1. of RFC3550.
  double jitter;

  /// Total bytes received by this track in the current session.
  int bytesReceived;

  /// Incoming bitrate of this track observed since previous report in Kb/s.
  double bitrate;

  /// Total packets received by this track in the current session.
  int packetsReceived;

  /// Total packets lost by this track in the current session.
  int packetsLost;

  HMSRemoteAudioStats(
      {required this.bytesReceived,
      required this.jitter,
      required this.bitrate,
      required this.packetsLost,
      required this.packetsReceived});

  factory HMSRemoteAudioStats.fromMap(Map map) {
    return HMSRemoteAudioStats(
        bytesReceived: map["bytes_received"],
        jitter: map["jitter"],
        bitrate: map["bitrate"],
        packetsLost: map['packets_lost'],
        packetsReceived: map['packets_received']);
  }
}
