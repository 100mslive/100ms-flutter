


# HMSPeer.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSPeer.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
factory HMSPeer.fromMap(Map map) {
  HMSRole? role;
  if (map['role'] != null) role = HMSRole.fromMap(map['role']);
  return HMSPeer(
    peerId: map['peer_id'],
    name: map['name'],
    isLocal: map['is_local'],
    role: role,
    customerDescription: map['customer_description'],
    customerUserId: map['customer_user_id'],

  );
}
```







