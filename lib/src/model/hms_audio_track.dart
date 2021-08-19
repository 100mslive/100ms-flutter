import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/common/platform_methods.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///parent of all audio tracks
class HMSAudioTrack extends HMSTrack {
  HMSAudioTrack(
      {required HMSTrackKind kind,
      required HMSTrackSource source,
      required String trackId,
      required String trackDescription})
      : super(
          kind: kind,
          source: source,
          trackDescription: trackDescription,
          trackId: trackId,
        );

  ///returns true if audio is mute
  @override
  Future<bool> isMute() async {
    //TODO:: make platform call
    return await PlatformService.invokeMethod(PlatformMethod.isAudioMute,
        arguments: {"peer_id": peer!.peerId, "is_local": peer!.isLocal});
  }
}
