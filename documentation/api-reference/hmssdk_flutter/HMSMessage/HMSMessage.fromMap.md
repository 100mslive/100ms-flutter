


# HMSMessage.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSMessage.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
factory HMSMessage.fromMap(Map map) {
  print(map.toString());
  return HMSMessage(
    sender: map['sender'] as String,
    message: map['message'] as String,
    type: map['type'] as String,
    time: map['time'] as String,
  );
}
```







