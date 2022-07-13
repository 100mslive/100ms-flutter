import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerTrackNode {
  HMSVideoTrack hmsVideoTrack;
  bool isMute = true;
  HMSPeer peer;
  bool isOffScreen = true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeerTrackNode &&
          runtimeType == other.runtimeType &&
          isMute == other.isMute &&
          peer == other.peer &&
          isOffScreen == other.isOffScreen;

  @override
  int get hashCode => isMute.hashCode ^ peer.hashCode ^ isOffScreen.hashCode;

  PeerTrackNode(this.hmsVideoTrack, this.isMute, this.peer,
      {this.isOffScreen = false});
}
