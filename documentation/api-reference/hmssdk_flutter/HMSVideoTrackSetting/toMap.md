


# toMap method




    *[<Null safety>](https://dart.dev/null-safety)*




[Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html), dynamic> toMap
()








## Implementation

```dart
Map<String, dynamic> toMap() {
  return {
    'codec': HMSCodecValues.getValueFromHMSCodec(codec),
    'bit_rate': maxBitrate,
    'max_frame_rate': maxFrameRate,
    'track_description': trackDescription,
    'resolution': resolution?.toMap(),
    'camera_facing':
        HMSCameraFacingValues.getValueFromHMSCameraFacing(cameraFacing)
  };
}
```







