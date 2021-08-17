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
      required String trackDescription})
      : super(
          kind: kind,
          source: source,
          trackDescription: trackDescription,
          trackId: trackId,
        );

  @override
  Future<bool> isMute() async {
    //TODO:: make platform call
    return await PlatformService.invokeMethod(PlatformMethod.isVideoMute,
        arguments: {"peer_id": peer!.peerId, "is_local": peer!.isLocal});
  }
}
