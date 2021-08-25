


# getHMSCameraFacingFromName method




    *[<Null safety>](https://dart.dev/null-safety)*




[HMSCameraFacing](../../hmssdk_flutter/HMSCameraFacing-class.md) getHMSCameraFacingFromName
([String](https://api.flutter.dev/flutter/dart-core/String-class.html) name)








## Implementation

```dart
static HMSCameraFacing getHMSCameraFacingFromName(String name) {
  switch (name) {
    ///front camera is being used
    case 'kHMSCameraFacingFront':
      return HMSCameraFacing.kHMSCameraFacingFront;
    ///rear camera is being used
    case 'kHMSCameraFacingBack':
      return HMSCameraFacing.kHMSCameraFacingBack;

    default:
      return HMSCameraFacing.unknown;
  }
}
```







