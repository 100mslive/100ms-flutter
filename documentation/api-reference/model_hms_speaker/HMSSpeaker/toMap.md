


# toMap method




    *[<Null safety>](https://dart.dev/null-safety)*




[Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html), dynamic> toMap
()








## Implementation

```dart
Map<String, dynamic> toMap() {
  // ignore: unnecessary_cast
  return {
    'peerId': this.peerId,
    'trackId': this.trackId,
    'audioLevel': this.audioLevel,
  } as Map<String, dynamic>;
}
```







