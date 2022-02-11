import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:mobx/mobx.dart';

part 'peer_track_node.g.dart';

class PeerTrackNode = PeerTracKNodeBase with _$PeerTrackNode;

abstract class PeerTracKNodeBase with Store {
  @observable
  HMSPeer peer;

  String uid;

  @observable
  HMSVideoTrack? track;

  @observable
  bool? isVideoOn;


  PeerTracKNodeBase(
      {required this.peer,
      this.track,
      required this.uid,
      required this.isVideoOn,
      });

  @override
  String toString() {
    return 'PeerTracKNode{peerId: ${peer.peerId}, name: ${peer.name}, track: $track}, isVideoOn: $isVideoOn }';
  }

  @override
  int get hashCode => peer.peerId.hashCode;
}
