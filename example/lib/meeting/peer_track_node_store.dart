import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:mobx/mobx.dart';

part 'peer_track_node_store.g.dart';

class PeerTrackNodeStore = PeerTracKNodeStoreBase with _$PeerTrackNodeStore;

abstract class PeerTracKNodeStoreBase with Store {
  @observable
  HMSPeer peer;

  String uid;

  @observable
  HMSVideoTrack? track;

  @observable
  bool? isVideoOn;

  @observable
  bool isHighestAudio;

  PeerTracKNodeStoreBase(
      {required this.peer,
      this.track,
      required this.uid,
      required this.isVideoOn,
      this.isHighestAudio = false});

  @override
  String toString() {
    return 'PeerTracKNode{peerId: ${peer.peerId}, name: ${peer.name}, track: $track}, isVideoOn: $isVideoOn }';
  }

  @override
  int get hashCode => peer.peerId.hashCode;
}
