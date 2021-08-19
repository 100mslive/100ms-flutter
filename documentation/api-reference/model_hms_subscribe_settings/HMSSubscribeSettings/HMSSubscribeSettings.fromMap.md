


# HMSSubscribeSettings.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSSubscribeSettings.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
factory HMSSubscribeSettings.fromMap(Map map) {
  return HMSSubscribeSettings(
      maxSubsBitRate: map['max_subs_bit_rate'],
      maxDisplayTiles: map['map_display_tiles'],
      subcribesToRoles: map['subscribe_to_roles']);
}
```







