


# HMSVideoTrackSetting.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSVideoTrackSetting.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
factory HMSVideoTrackSetting.fromMap(Map map) {
  HMSVideoResolution? resolution;
  if (map.containsKey('resolution')) {
    resolution = HMSVideoResolution.fromMap(map['resolution']);
  }
  return HMSVideoTrackSetting(
      codec: HMSCodecValues.getHMSCodecFromName(map['codec']),
      resolution: resolution,
      maxBitrate: map['bit_rate'] ?? 0,
      maxFrameRate: map['max_frame_rate'] ?? 0,
      cameraFacing: HMSCameraFacingValues.getHMSCameraFacingFromName(
          map['camera_facing']),
      trackDescription: map['track_description']);
}
```







