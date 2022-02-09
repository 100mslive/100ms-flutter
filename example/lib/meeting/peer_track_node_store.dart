import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:mobx/mobx.dart';

part 'peer_track_node_store.g.dart';

class PeerTrackNodeStore = PeerTracKNodeStoreBase with _$PeerTrackNodeStore;


abstract class PeerTracKNodeStoreBase with Store{

  @observable
  HMSPeer peer;

  String uid;

  @observable
  HMSVideoTrack? track;



  PeerTracKNodeStoreBase({required this.peer, this.track,required this.uid});



  @override
  String toString() {
    return 'PeerTracKNode{peerId: ${peer.peerId}, name: ${peer.name}, track: $track}';
  }

  @override
  int get hashCode => peer.peerId.hashCode;
}