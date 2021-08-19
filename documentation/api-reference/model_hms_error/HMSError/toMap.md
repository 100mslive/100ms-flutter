


# toMap method




    *[<Null safety>](https://dart.dev/null-safety)*




[Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html), dynamic> toMap
()








## Implementation

```dart
Map<String, dynamic> toMap() {
  return {
    'id': this.id,
    'name': this.id,
    'code': code?.errorCode ?? '',
    'message': this.message,
    'info': this.description,
    'description': this.description,
    'action': this.action,
    'params': this.params,
  };
}
```







