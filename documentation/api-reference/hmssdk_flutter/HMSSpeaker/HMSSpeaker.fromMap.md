


# HMSSpeaker.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSSpeaker.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html), dynamic> map)





## Implementation

```dart
factory HMSSpeaker.fromMap(Map<String, dynamic> map) {
  return new HMSSpeaker(
    peerId: map['peerId'] as String,
    trackId: map['trackId'] as String,
    audioLevel: map['audioLevel'] as String,
  );
}
```







