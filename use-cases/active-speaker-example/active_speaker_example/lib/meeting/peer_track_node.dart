import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerTrackNode {
  HMSPeer peer;
  String uid;
  HMSVideoTrack? track;
  bool isActiveSpeaker;

  PeerTrackNode({required this.peer, this.track, required this.uid,this.isActiveSpeaker = false});

  @override
  String toString() {
    return 'PeerTrackNode{uid: $uid,peerId: ${peer.peerId}, name: ${peer.name}, track: ${track.toString()}}}';
  }
}
