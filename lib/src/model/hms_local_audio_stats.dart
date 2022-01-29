class HMSLocalAudioStats {
  double roundTripTime;
  int bytesSent;
  double bitrate;

  HMSLocalAudioStats({
    required this.roundTripTime,
    required this.bytesSent,
    required this.bitrate,
  });

  factory HMSLocalAudioStats.fromMap(Map map) {
    return HMSLocalAudioStats(
      roundTripTime: map["round_trip_time"],
      bytesSent: map["bytes_sent"],
      bitrate: map["bitrate"],
    );
  }
}
