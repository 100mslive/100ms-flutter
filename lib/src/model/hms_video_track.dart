// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSVideoTrack
///
///[HMSVideoTrack] contains information about video track of peer.
class HMSVideoTrack extends HMSTrack {
  final bool isDegraded;

  HMSVideoTrack({
    this.isDegraded = false,
    required HMSTrackKind kind,
    required String source,
    required String trackId,
    required String trackDescription,
    required bool isMute,
  }) : super(
          kind: kind,
          source: source,
          trackDescription: trackDescription,
          trackId: trackId,
          isMute: isMute,
        );

  factory HMSVideoTrack.fromMap({required Map map}) {
    return map['hms_video_track_settings'] == null
        ? HMSRemoteVideoTrack.fromMap(map: map)
        : HMSLocalVideoTrack.fromMap(map: map);
  }
}
