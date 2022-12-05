// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSSpeaker {
  final HMSPeer peer;
  final HMSTrack track;
  final int audioLevel;

  factory HMSSpeaker.fromMap(Map data) {
    HMSPeer peer = HMSPeer.fromMap(data['peer']);
    return new HMSSpeaker(
      peer: peer,
      track: data['track']['instance_of']
          ? HMSVideoTrack.fromMap(map: data['track'], isLocal: peer.isLocal)
          : HMSAudioTrack.fromMap(map: data['track'], isLocal: peer.isLocal),
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
