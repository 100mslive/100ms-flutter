import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/common/platform_methods.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSLocalVideoTrack extends HMSVideoTrack {
  final HMSVideoTrackSetting setting;

  HMSLocalVideoTrack(
      {required this.setting,
      required bool isDegraded,
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

  Future<void> startCapturing() async {
    await PlatformService.invokeMethod(PlatformMethod.startCapturing);
  }

  Future<void> stopCapturing() async {
    await PlatformService.invokeMethod(PlatformMethod.stopCapturing);
  }

  Future<void> switchCamera() async {
    await PlatformService.invokeMethod(PlatformMethod.switchCamera);
  }

  factory HMSLocalVideoTrack.fromMap({required Map map, HMSPeer? peer}) {
    return HMSLocalVideoTrack(
        trackId: map['track_id'],
        trackDescription: map['track_description'],
        source: (map['track_source']),
        kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
        isMute: map['track_mute'],
        isDegraded: map['is_degraded'],
        peer: peer, setting: HMSVideoTrackSetting.fromMap(map["hms_video_track_settings"]));
  }
}
