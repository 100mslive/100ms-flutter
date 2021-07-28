class HMSAudioTrackSetting {
  final int maxBitrate;
  final String trackDescription;

  HMSAudioTrackSetting(
      {required this.maxBitrate, required this.trackDescription});

  factory HMSAudioTrackSetting.fromMap(Map map) {
    return HMSAudioTrackSetting(
        maxBitrate: map['bit_rate'],
        trackDescription: map['track_description']);
  }

  Map<String, dynamic> toMap() {
    return {'bit_rate': maxBitrate, 'track_description': trackDescription};
  }
}
