


# getValueFromHMSCameraFacing method




    *[<Null safety>](https://dart.dev/null-safety)*




[String](https://api.flutter.dev/flutter/dart-core/String-class.html) getValueFromHMSCameraFacing
([HMSCameraFacing](../../enum_hms_camera_facing/HMSCameraFacing-class.md) hmsCameraFacing)








## Implementation

```dart
static String getValueFromHMSCameraFacing(HMSCameraFacing hmsCameraFacing) {
  switch (hmsCameraFacing) {
    case HMSCameraFacing.kHMSCameraFacingFront:
      return 'kHMSCameraFacingFront';
    case HMSCameraFacing.kHMSCameraFacingBack:
      return 'kHMSCameraFacingVideo';
    case HMSCameraFacing.unknown:
      return '';
  }
}
```







