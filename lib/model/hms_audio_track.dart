import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/enum/hms_track_kind.dart';
import 'package:hmssdk_flutter/enum/hms_track_source.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/service/platform_service.dart';

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

  @override
  Future<bool> isMute() async {
    //TODO:: make platform call
    return await PlatformService.invokeMethod(PlatformMethod.isAudioMute,arguments: {"peer_id":peer!.peerId,"is_local":peer!.isLocal});
  }
}
