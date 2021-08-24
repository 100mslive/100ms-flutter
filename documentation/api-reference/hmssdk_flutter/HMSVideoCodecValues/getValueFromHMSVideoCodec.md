


# getValueFromHMSVideoCodec method




    *[<Null safety>](https://dart.dev/null-safety)*




[String](https://api.flutter.dev/flutter/dart-core/String-class.html) getValueFromHMSVideoCodec
([HMSVideoCodec](../../hmssdk_flutter/HMSVideoCodec-class.md) hMSVideoCodec)








## Implementation

```dart
static String getValueFromHMSVideoCodec(HMSVideoCodec hMSVideoCodec) {
  switch (hMSVideoCodec) {
    case HMSVideoCodec.h264:
      return 'h264';
    case HMSVideoCodec.vp8:
      return 'vp8';
    case HMSVideoCodec.vp9:
      return 'vp9';
    case HMSVideoCodec.h265:
      return 'h265';
    case HMSVideoCodec.unknown:
      return 'unknown';
  }
}
```







