import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSRoom {
  final String id;
  final String name;
  final String? metaData;
  final List<HMSPeer>? peers;

  HMSRoom(
      {required this.id,
      required this.name,
      required this.peers,
      this.metaData});

  factory HMSRoom.fromMap(Map map) {
    List<HMSPeer> peers = [];
    print("HMSRoom ${map.toString()}");
    if (map.containsKey('peers') && map['peers'] is List) {
      for (var each in (map['peers'] as List)) {
        try {
          HMSPeer peer = HMSPeer.fromMap(each);
          peers.add(peer);
        } catch (e) {
          print(e);
        }
      }
    }

    return HMSRoom(
        id: map['id'],
        name: map['name'],
        peers: peers,
        metaData: map['meta_data']);
  }
}
