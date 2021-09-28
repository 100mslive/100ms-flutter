class HMSSpeaker {
  final String peerId;
  final String trackId;
  final int audioLevel;

  factory HMSSpeaker.fromMap(Map map) {
    return new HMSSpeaker(
      peerId: map['peerId'] as String,
      trackId: map['trackId'] as String,
      audioLevel: map['audioLevel'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'peerId': this.peerId,
      'trackId': this.trackId,
      'audioLevel': this.audioLevel,
    } as Map<String, dynamic>;
  }

  HMSSpeaker(
      {required this.peerId, required this.trackId, required this.audioLevel});
}
