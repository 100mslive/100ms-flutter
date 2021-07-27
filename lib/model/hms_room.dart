import 'package:hmssdk_flutter/model/hms_peer.dart';

class HMSRoom {
  final String id;
  final String name;
  final String? metaData;
  final List<HMSPeer> peers;
  final HMSPeer? localPeer;

  HMSRoom(
      {required this.id,
      required this.name,
      required this.peers,
        required this.localPeer,
      this.metaData});

  factory HMSRoom.fromMap(Map map) {
    return HMSRoom(
        id: map['id'],
        name: map['name'],
        localPeer: map['local_peer']!=null?HMSPeer.fromMap(map['local_peer']):null,
        peers: HMSPeer.fromListOfMap(map['peers'] ?? []),
        metaData: map['meta_data']??"");
  }
}
