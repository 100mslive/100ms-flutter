


# HMSLocalPeer.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSLocalPeer.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
factory HMSLocalPeer.fromMap(Map map) {
  return HMSLocalPeer(
    peerId: map['peer_id'],
    name: map['name'],
    isLocal: map['is_local'],
    role: HMSRole.fromMap(map['role']),
    customerDescription: map['customer_description'],
    customerUserId: map['customer_user_id'],
  );
}
```







