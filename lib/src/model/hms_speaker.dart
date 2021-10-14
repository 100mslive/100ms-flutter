import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSSpeaker {
  final HMSPeer peer;
  final String trackId;
  final int audioLevel;

  factory HMSSpeaker.fromMap(Map map) {
    return new HMSSpeaker(
      peer: HMSPeer.fromMap(map['peer']),
      trackId: map['trackId'] as String,
      audioLevel: map['audioLevel'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'peer': this.peer,
      'trackId': this.trackId,
      'audioLevel': this.audioLevel,
    } as Map<String, dynamic>;
  }

  HMSSpeaker(
      {required this.peer, required this.trackId, required this.audioLevel});
}
