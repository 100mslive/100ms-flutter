


# getValueFromHMSCodec method




    *[<Null safety>](https://dart.dev/null-safety)*




[String](https://api.flutter.dev/flutter/dart-core/String-class.html) getValueFromHMSCodec
([HMSCodec](../../enum_hms_codec/HMSCodec-class.md) hmsCodec)








## Implementation

```dart
static String getValueFromHMSCodec(HMSCodec hmsCodec) {
  switch (hmsCodec) {
    case HMSCodec.kHMSCodecH264:
      return 'kHMSCodecH264';
    case HMSCodec.kHMSCodecVP8:
      return 'kHMSCodecVP8';
    case HMSCodec.unknown:
      return '';
  }
}
```







