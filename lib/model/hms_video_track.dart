import 'package:flutter/widgets.dart';
import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/enum/hms_track_kind.dart';
import 'package:hmssdk_flutter/enum/hms_track_source.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/service/platform_service.dart';

class HMSVideoTrack extends HMSTrack {
  @override
  Future<bool> isMute() async {
    bool isMuted = await PlatformService.invokeMethod(PlatformMethod.isVideoMute);
    return isMuted;
  }

  HMSVideoTrack({required HMSTrackKind kind,required HMSTrackSource source,
     required String trackDescription,required String trackID}) : super(trackID, kind, source, trackDescription);

  factory HMSVideoTrack.fromMap(Map map) {
    debugPrint(map.toString());
    if(map==null) {
      map={"track_kind":"","track_source":"","track_id":"-1","track_description":""};
    }
    return HMSVideoTrack(
      kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
      source: HMSTrackSourceValue.getHMSTrackSourceFromName(map['track_source']),
      trackID: map['track_id'],
      trackDescription: map['track_description']??"",

    );
  }

  @override
  String toString() {
    return 'HMSVideoTrack{peerId: $kind, name: $source, isLocal: $trackID, role: $trackDescription}';
  }
}
