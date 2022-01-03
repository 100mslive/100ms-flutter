// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSVideoTrack extends HMSTrack {
  final bool isDegraded;

  HMSVideoTrack(
      {this.isDegraded = false,
      required HMSTrackKind kind,
      required String source,
      required String trackId,
      required String trackDescription,
      required bool isMute,
      HMSPeer? peer})
      : super(
            kind: kind,
            source: source,
            trackDescription: trackDescription,
            trackId: trackId,
            isMute: isMute,
            peer: peer);

  factory HMSVideoTrack.fromMap({required Map map, HMSPeer? peer}) {
    return map['hms_video_track_settings'] == null
        ? HMSVideoTrack(
            trackId: map['track_id'],
            trackDescription: map['track_description'],
            source: (map['track_source']),
            kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
            isMute: map['track_mute'],
            isDegraded: map['is_degraded'],
            peer: peer)
        : HMSLocalVideoTrack.fromMap(map: map, peer: peer);
  }
}
