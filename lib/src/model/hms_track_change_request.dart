// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSTrackChangeRequest
///
///when someone requests for track change of yours be it video or audio this will be triggered
///
/// [HMSTrackChangeRequest] request instance consisting of all the required info about track change
class HMSTrackChangeRequest {
  bool mute;
  HMSPeer requestBy;
  HMSTrack track;

  HMSTrackChangeRequest(
      {required this.mute, required this.requestBy, required this.track});

  Map<String, dynamic> toMap() {
    return {
      'mute': this.mute,
      'requested_by': this.requestBy,
      'track': this.track,
    };
  }

  factory HMSTrackChangeRequest.fromMap(Map map) {
    return HMSTrackChangeRequest(
      mute: map['mute'] as bool,
      requestBy: HMSPeer.fromMap(map['requested_by']),
      track: HMSTrack.fromMap(map: map['track']),
    );
  }
}
