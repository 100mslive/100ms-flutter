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
}
