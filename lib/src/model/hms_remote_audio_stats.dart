class HMSRemoteAudioStats {
  int bytesReceived;
  double bitrate;
  double jitter;
  int packetsReceived;
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
