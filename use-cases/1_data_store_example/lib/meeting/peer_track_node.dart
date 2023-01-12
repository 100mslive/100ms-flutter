//Class which unifies HMSPeer and HMSTrack for each peer
///[uid] This is unique id for each peer
///For normal video uid is defined as "peerId+mainVideo"
///For screen share tracks it is defined as peerId+trackId
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
