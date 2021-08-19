


# HMSVideoSetting.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSVideoSetting.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
factory HMSVideoSetting.fromMap(Map map) {
  return HMSVideoSetting(
      bitRate: map['bit_rate'] ?? 0,
      codec: HMSVideoCodecValues.getHMSCodecFromName(map['codec'] ?? ''),
      frameRate: map['frame_rate'],
      width: map['width'],
      height: map['height']);
}
```







