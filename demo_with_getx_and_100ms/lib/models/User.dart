

import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class User{
  HMSVideoTrack hmsVideoTrack;
  bool isVideoOn;
  HMSPeer peer;

  User(this.hmsVideoTrack, this.isVideoOn,this.peer);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          hmsVideoTrack == other.hmsVideoTrack;

  @override
  String toString() {
    return 'User{isVideoOn: $isVideoOn}';
  }

  @override
  int get hashCode =>
      hmsVideoTrack.hashCode ^ peer.hashCode;
}