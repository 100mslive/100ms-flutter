// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSRemoteVideoTrack extends HMSVideoTrack {
  HMSRemoteVideoTrack(
      {required bool isDegraded,
      required HMSTrackKind kind,
      required String source,
      required String trackId,
      required String trackDescription,
      required bool isMute,
      HMSPeer? peer})
      : super(
            isDegraded: isDegraded,
            kind: kind,
            source: source,
            trackDescription: trackDescription,
            trackId: trackId,
            isMute: isMute,
            peer: peer);

  factory HMSRemoteVideoTrack.fromMap({required Map map, HMSPeer? peer}) {
    return HMSRemoteVideoTrack(
      trackId: map['track_id'],
      trackDescription: map['track_description'],
      source: (map['track_source']),
      kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
      isMute: map['track_mute'],
      isDegraded: map['is_degraded'],
      peer: peer,
    );
  }
}
