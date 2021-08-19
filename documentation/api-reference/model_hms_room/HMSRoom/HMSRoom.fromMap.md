


# HMSRoom.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSRoom.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
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
```







