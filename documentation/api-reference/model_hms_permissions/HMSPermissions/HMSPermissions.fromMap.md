


# HMSPermissions.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSPermissions.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
factory HMSPermissions.fromMap(Map map) {
  return HMSPermissions(
      endRoom: map['end_room'],
      removeOthers: map['remove_others'],
      stopPresentation: map['stop_presentation'],
      muteAll: map['mute_all'],
      askToUnMute: map['ask_to_un_mute'],
      muteSelective: map['mute_selective'],
      changeRole: map['change_role']);
}
```







