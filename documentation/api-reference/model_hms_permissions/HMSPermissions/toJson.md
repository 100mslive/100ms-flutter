


# toJson method




    *[<Null safety>](https://dart.dev/null-safety)*




[Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html), dynamic> toJson
()








## Implementation

```dart
Map<String, dynamic> toJson() {
  return {
    'end_room': endRoom,
    'stop_presentation': stopPresentation,
    'remove_others': removeOthers,
    'mute_all': muteAll,
    'ask_to_un_mute': askToUnMute,
    'mute_selective': muteSelective,
    'change_role': changeRole
  };
}
```







