import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSSpeaker {
  final HMSPeer peer;
  final HMSTrack? track;
  final int audioLevel;

  factory HMSSpeaker.fromMap(Map map) {
    return new HMSSpeaker(
      peer: HMSPeer.fromMap(map['peer']),
      track: map["track"] == null ? null : HMSTrack.fromMap(map: map['track']),
      audioLevel: map['audioLevel'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'peer': this.peer,
      'track': this.track,
      'audioLevel': this.audioLevel,
    } as Map<String, dynamic>;
  }

  HMSSpeaker({
    required this.peer,
    required this.track,
    required this.audioLevel,
  });
}
