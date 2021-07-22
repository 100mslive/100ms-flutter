import 'package:flutter/foundation.dart';
import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/enum/hms_track_kind.dart';
import 'package:hmssdk_flutter/enum/hms_track_source.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/service/platform_service.dart';

class HMSAudioTrack extends HMSTrack {
  HMSAudioTrack({required String trackID,required HMSTrackKind kind,required HMSTrackSource source,required String trackDescription}) : super(trackID, kind, source, trackDescription);

  @override
  Future<bool> isMute() async {
    bool isMuted = await PlatformService.invokeMethod(PlatformMethod.isAudioMute);
    return isMuted;
  }

  factory HMSAudioTrack.fromMap(Map map) {
    debugPrint(map.toString()+"HMSAudioTrack");
    return HMSAudioTrack(
      kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
      source: HMSTrackSourceValue.getHMSTrackSourceFromName(map['track_source']),
      trackID: map['track_id'],
      trackDescription: map['track_description']??"",
    );
  }

  @override
  String toString() {
    return 'HMSAudioTrack{peerId: $kind, name: $source, isLocal: $trackID, role: $trackDescription}';
  }

}
