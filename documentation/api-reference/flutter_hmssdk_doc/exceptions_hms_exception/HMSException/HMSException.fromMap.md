


# HMSException.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSException.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
factory HMSException.fromMap(Map map) {
  print(1);
  return HMSException(
    map['description'],
    map['message'],
    map['code'],
    map['action'],
    map['name'],
  );
}
```







