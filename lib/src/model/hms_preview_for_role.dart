import 'dart:core';

import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PreviewForRole {
  HMSLocalVideoTrack? hmsLocalVideoTrack;
  HMSLocalAudioTrack? hmsLocalAudioTrack;

  PreviewForRole({this.hmsLocalVideoTrack, this.hmsLocalAudioTrack});

  factory PreviewForRole.fromMap(Map map) {
    return PreviewForRole(
        hmsLocalAudioTrack: HMSLocalAudioTrack.fromMap(map: map["audio"]),
        hmsLocalVideoTrack: HMSLocalVideoTrack.fromMap(map: map["video"]));
  }
}
