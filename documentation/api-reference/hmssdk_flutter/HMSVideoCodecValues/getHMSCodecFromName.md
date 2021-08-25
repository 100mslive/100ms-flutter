


# getHMSCodecFromName method




    *[<Null safety>](https://dart.dev/null-safety)*




[HMSVideoCodec](../../hmssdk_flutter/HMSVideoCodec-class.md) getHMSCodecFromName
([String](https://api.flutter.dev/flutter/dart-core/String-class.html) name)








## Implementation

```dart
static HMSVideoCodec getHMSCodecFromName(String name) {
  switch (name) {
    case 'h264':
      return HMSVideoCodec.h264;
    case 'vp8':
      return HMSVideoCodec.vp8;
    case 'vp9':
      return HMSVideoCodec.vp9;
    case 'h265':
      return HMSVideoCodec.h265;
    default:
      return HMSVideoCodec.unknown;
  }
}
```







