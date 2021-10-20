///100ms HMSRoom
///
///To use,import package import `package:hmssdk_flutter/model/hms_room`.
///
///HMSRoom building block around which whole system is made contains all stuff related to room.
///
/// This library depends only on core Dart libraries and the `hms_peer.dart` library.
///
///A [room] is the basic object that 100ms SDKs return on successful connection. This contains references to peers, tracks and everything you need to render a live a/v app.
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSRoom {
  ///[id] of the room
  String? id;
  String? name;
  String? metaData;

  ///[peers] list which are in the room.
  final List<HMSPeer>? peers;

  HMSRoom({this.id, this.name, required this.peers, this.metaData});

  factory HMSRoom.fromMap(Map map) {
    List<HMSPeer> peers = [];
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
