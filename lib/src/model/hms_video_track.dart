import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/common/platform_methods.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSVideoTrack extends HMSTrack {
  final bool isDegraded;

  HMSVideoTrack(
      {this.isDegraded = false,
      required HMSTrackKind kind,
      required HMSTrackSource source,
      required String trackId,
      required String trackDescription,required bool isMute,HMSPeer? peer})
      : super(
          kind: kind,
          source: source,
          trackDescription: trackDescription,
          trackId: trackId,
          isMute: isMute,
          peer: peer
        );

  factory HMSVideoTrack.fromMap({required Map map, HMSPeer? peer}) {
    return HMSVideoTrack(
        trackId: map['track_id'],
        trackDescription: map['track_description'],
        source:
        HMSTrackSourceValue.getHMSTrackSourceFromName(map['track_source']),
        kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
        isMute: map['track_mute'],
        peer: peer);
  }
}
