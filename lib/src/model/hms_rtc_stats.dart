class HMSRTCStats {
  Map combined;
  Map audio;
  Map video;

  HMSRTCStats(
      {required this.combined, required this.audio, required this.video});

  factory HMSRTCStats.fromMap(Map map) {
    return HMSRTCStats(
      combined: map["combined"],
      audio: map["audio"],
      video: map["video"],
    );
  }
}
