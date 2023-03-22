import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:mobx/mobx.dart';

@observable
class PeerTrackNode {
  String uid;
  HMSPeer peer;
  @observable
  String name;
  bool isRaiseHand;
  @observable
  HMSVideoTrack? track;
  @observable
  bool isOffScreen;
  PeerTrackNode(
      {required this.uid,
      required this.peer,
      this.track,
      this.name = "",
      this.isRaiseHand = false,
      this.isOffScreen = false});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeerTrackNode &&
          runtimeType == other.runtimeType &&
          uid == other.uid;

  @override
  String toString() {
    return 'PeerTracKNode{peerId: ${peer.peerId}, name: $name, track: $track}';
  }

  @override
  int get hashCode => peer.peerId.hashCode;
}
