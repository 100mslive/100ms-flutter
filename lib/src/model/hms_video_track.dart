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
        ? HMSRemoteVideoTrack.fromMap(map: map,peer: peer)
        : HMSLocalVideoTrack.fromMap(map: map, peer: peer);
  }
}
