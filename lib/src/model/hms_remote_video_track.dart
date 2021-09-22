import 'package:hmssdk_flutter/hmssdk_flutter.dart';

import 'hms_video_track_setting.dart';

class HMSRemoteVideoTrack extends HMSVideoTrack {
  final HMSVideoTrackSetting setting;

  HMSRemoteVideoTrack(
      {required this.setting,
      required bool isDegraded,
      required HMSTrackKind kind,
      required HMSTrackSource source,
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
            peer: peer
            );

}
