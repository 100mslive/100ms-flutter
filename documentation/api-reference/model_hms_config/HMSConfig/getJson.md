


# getJson method




    *[<Null safety>](https://dart.dev/null-safety)*




[Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html), dynamic> getJson
()








## Implementation

```dart
Map<String, dynamic> getJson() {
  return {
    'user_name': userName,
    'user_id': userId,
    'room_id': roomId,
    'auth_token': authToken,
    'meta_data': metaData,
    'should_skip_pii_events': shouldSkipPIIEvents,
    'end_point': endPoint
  };
}
```







