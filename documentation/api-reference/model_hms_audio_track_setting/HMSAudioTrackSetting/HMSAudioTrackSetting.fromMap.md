


# HMSAudioTrackSetting.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSAudioTrackSetting.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
factory HMSAudioTrackSetting.fromMap(Map map) {
  return HMSAudioTrackSetting(
      maxBitrate: map['bit_rate'],
      trackDescription: map['track_description']);
}
```







