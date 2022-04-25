// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///100ms HMSRemoteAudioTrack
///
///[HMSLocalVideoTrack] contains the remote peer audio track infomation.
class HMSRemoteAudioTrack extends HMSAudioTrack {
  HMSRemoteAudioTrack({
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

  factory HMSRemoteAudioTrack.fromMap({required Map map}) {
    return HMSRemoteAudioTrack(
      trackId: map['track_id'],
      trackDescription: map['track_description'],
      source: map['track_source'],
      kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
      isMute: map['track_mute'],
    );
  }

  Future<HMSException?> setVolume(double volume) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.setVolume,
        arguments: {"track_id": trackId, "volume": volume.toDouble()});

    if (result == null) {
      return null;
    } else {
      return HMSException.fromMap(result["error"]);
    }
  }
}
