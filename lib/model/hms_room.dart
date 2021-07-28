import 'package:hmssdk_flutter/model/hms_peer.dart';

class HMSRoom {
  final String id;
  final String name;
  final String? metaData;
  final List<HMSPeer> peers;

  HMSRoom(
      {required this.id,
      required this.name,
      required this.peers,
      this.metaData});

  factory HMSRoom.fromMap(Map map) {
    return HMSRoom(
        id: map['id'],
        name: map['name'],
        peers: HMSPeer.fromListOfMap(map['peers'] ?? []),
        metaData: map['meta_data']);
  }
}
