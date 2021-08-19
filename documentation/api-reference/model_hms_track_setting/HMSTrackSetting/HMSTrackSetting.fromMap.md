


# HMSTrackSetting.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSTrackSetting.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html), dynamic> map)





## Implementation

```dart
factory HMSTrackSetting.fromMap(Map<String, dynamic> map) {
  HMSAudioTrackSetting? audioTrackSetting;
  HMSVideoTrackSetting? videoTrackSetting;
  if (map.containsKey('audio_track_setting')) {
    audioTrackSetting =
        HMSAudioTrackSetting.fromMap(map['audio_track_setting']);
  }
  if (map.containsKey('video_track_setting')) {
    videoTrackSetting =
        HMSVideoTrackSetting.fromMap(map['video_track_setting']);
  }
  return HMSTrackSetting(
    audioTrackSetting: audioTrackSetting,
    videoTrackSetting: videoTrackSetting,
  );
}
```







