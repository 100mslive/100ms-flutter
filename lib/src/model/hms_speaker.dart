// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSSpeaker {
  final HMSPeer peer;
  final HMSTrack? track;
  final int audioLevel;

  factory HMSSpeaker.fromMap(Map data) {
    return new HMSSpeaker(
      peer: HMSPeer.fromMap(data['peer']),
      track: data["track"] == null
          ? null
          : data['track']['instance_of']
              ? HMSVideoTrack.fromMap(map: data['track'], peer: null)
              : HMSAudioTrack.fromMap(map: data['track'], peer: null),
      audioLevel: data['audioLevel'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'peer': this.peer,
      'track': this.track,
      'audioLevel': this.audioLevel,
    };
  }

  HMSSpeaker({
    required this.peer,
    required this.track,
    required this.audioLevel,
  });
}
