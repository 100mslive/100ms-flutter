// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSSpeaker
///
///[HMSSpeaker] contains the peer info, track info and audioLevel.
class HMSSpeaker {
  final HMSPeer peer;
  final HMSTrack track;
  final int audioLevel;

  factory HMSSpeaker.fromMap(Map data) {
    HMSPeer peer = HMSPeer.fromMap(data['peer']);
    return HMSSpeaker(
      peer: peer,
      track: data['track']['instance_of']
          ? HMSVideoTrack.fromMap(map: data['track'], isLocal: peer.isLocal)
          : HMSAudioTrack.fromMap(map: data['track'], isLocal: peer.isLocal),
      audioLevel: data['audioLevel'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'peer': peer,
      'track': track,
      'audioLevel': audioLevel,
    };
  }

  HMSSpeaker({
    required this.peer,
    required this.track,
    required this.audioLevel,
  });
}
