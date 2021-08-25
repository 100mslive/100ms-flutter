


# fromListOfMap method




    *[<Null safety>](https://dart.dev/null-safety)*




[List](https://api.flutter.dev/flutter/dart-core/List-class.html)&lt;[HMSPeer](../../hmssdk_flutter/HMSPeer-class.md)> fromListOfMap
([List](https://api.flutter.dev/flutter/dart-core/List-class.html) peersMap)








## Implementation

```dart
static List<HMSPeer> fromListOfMap(List peersMap) {
  List<HMSPeer> peers = peersMap.map((e) => HMSPeer.fromMap(e)).toList();
  return peers;
}
```







