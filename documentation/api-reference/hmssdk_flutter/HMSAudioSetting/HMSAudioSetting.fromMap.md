


# HMSAudioSetting.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSAudioSetting.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
factory HMSAudioSetting.fromMap(Map map) {
  // TODO:: do not take input when no data is present
  return HMSAudioSetting(
      bitRate: map['bit_rate'] ?? 0,
      codec: HMSAudioCodecValues.getHMSCodecFromName(map['codec'] ?? ''));
}
```







