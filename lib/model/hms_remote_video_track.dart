
import 'package:hmssdk_flutter/enum/hms_track_kind.dart';
import 'package:hmssdk_flutter/enum/hms_track_source.dart';
import 'package:hmssdk_flutter/model/hms_video_track.dart';

import 'hms_video_track_setting.dart';

class HMSRemoteVideoTrack extends HMSVideoTrack{
  final HMSVideoTrackSetting setting;

  HMSRemoteVideoTrack(
      {required this.setting,
        required bool isDegraded,
        required HMSTrackKind kind,
        required HMSTrackSource source,
        required String trackId,
        required String trackDescription})
      : super(
    isDegraded: isDegraded,
    kind: kind,
    source: source,
    trackDescription: trackDescription,
    trackId: trackId,
  );

  @override
  Future<bool> isMute() {
    // TODO: implement isMute
    return super.isMute();
  }
}