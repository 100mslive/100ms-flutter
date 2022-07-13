// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///100ms HMSLocalVideoTrack
///
///[HMSLocalVideoTrack] contains the local peer video track infomation.
class HMSLocalVideoTrack extends HMSVideoTrack {
  HMSVideoTrackSetting setting;

  HMSLocalVideoTrack({
    required this.setting,
    required bool isDegraded,
    required HMSTrackKind kind,
    required String source,
    required String trackId,
    required String trackDescription,
    required bool isMute,
  }) : super(
          isDegraded: isDegraded,
          kind: kind,
          source: source,
          trackDescription: trackDescription,
          trackId: trackId,
          isMute: isMute,
        );

  Future<void> startCapturing() async {
    await PlatformService.invokeMethod(PlatformMethod.startCapturing);
  }

  Future<void> stopCapturing() async {
    await PlatformService.invokeMethod(PlatformMethod.stopCapturing);
  }

  Future<void> switchCamera() async {
    await PlatformService.invokeMethod(PlatformMethod.switchCamera);
  }

  factory HMSLocalVideoTrack.fromMap({required Map map}) {
    return HMSLocalVideoTrack(
        trackId: map['track_id'],
        trackDescription: map['track_description'],
        source: (map['track_source']),
        kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
        isMute: map['track_mute'],
        isDegraded: map['is_degraded'],
        setting: HMSVideoTrackSetting.fromMap(map["hms_video_track_settings"]));
  }

  set setHMSTrackSetting(HMSVideoTrackSetting hmsVideoTrackSetting) {
    this.setting = hmsVideoTrackSetting;
    PlatformService.invokeMethod(
        PlatformMethod.updateHMSLocalVideoTrackSettings,
        arguments: {"video_track_setting": this.setting.toMap()});
  }
}
