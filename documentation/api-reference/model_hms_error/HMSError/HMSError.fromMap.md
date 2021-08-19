


# HMSError.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSError.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
factory HMSError.fromMap(Map map) {
  HMSErrorCode? code;

  if (map.containsKey('code')) {
    code = HMSErrorCode(errorCode: map['code'].toString());
  }

  return HMSError(
    id: map["id"]??map['name'] ?? '',
    code: code,
    message: map['message'],
    action: map['action'],
    description: map['info'] ?? map['description'] ?? '',
    params: map['params'],
  );
}
```







