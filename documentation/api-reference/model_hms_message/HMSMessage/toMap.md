


# toMap method




    *[<Null safety>](https://dart.dev/null-safety)*




[Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html), dynamic> toMap
([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html), dynamic> map)








## Implementation

```dart
Map<String, dynamic> toMap(Map<String, dynamic> map) {
  return {
    'sender': sender,
    'message': message,
    'type': type,
    'time': time,
  };
}
```







