import 'package:hmssdk_flutter/enum/hms_track_kind.dart';
import 'package:hmssdk_flutter/enum/hms_track_source.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';

class HMSTrack {
  final String trackId;
  final HMSTrackKind kind;
  final HMSTrackSource source;
  final String trackDescription;
  final HMSPeer? peer;

  bool isMute() {
    return false;
  }

  const HMSTrack(
      {required this.kind,
      required this.source,
      required this.trackId,
      required this.trackDescription,
      this.peer});

  factory HMSTrack.fromMap(Map map, HMSPeer? peer) {
    //TODO:: parse hms audio and video tracks

    return HMSTrack(
        trackId: map['track_id'],
        trackDescription: map['track_description'],
        source:
            HMSTrackSourceValue.getHMSTrackSourceFromName(map['track_source']),
        kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
        peer: peer);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HMSTrack &&
          runtimeType == other.runtimeType &&
          trackId == other.trackId &&
          peer?.peerId == other.peer?.peerId;

  @override
  int get hashCode => trackId.hashCode;
}
