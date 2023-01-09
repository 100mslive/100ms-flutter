import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerTrackNode {
  HMSPeer peer;
  String uid;
  HMSVideoTrack? track;

  PeerTrackNode({required this.peer, this.track, required this.uid});

  @override
  String toString() {
    return 'PeerTrackNode{uid: $uid,peerId: ${peer.peerId}, name: ${peer.name}, track: ${track.toString()}}}';
  }
}
