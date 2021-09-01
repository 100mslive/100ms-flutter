import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSTrackChangeRequest {
  bool mute;
  HMSPeer requestBy;
  HMSTrack track;

  HMSTrackChangeRequest({required this.mute,required this.requestBy,required this.track});

  Map<String, dynamic> toMap() {
    return {
      'mute': this.mute,
      'requestBy': this.requestBy,
      'track': this.track,
    };
  }

  factory HMSTrackChangeRequest.fromMap(Map<String, dynamic> map) {
    return HMSTrackChangeRequest(
      mute: map['mute'] as bool,
      requestBy: map['requestBy'] as HMSPeer,
      track: map['track'] as HMSTrack,
    );
  }
}