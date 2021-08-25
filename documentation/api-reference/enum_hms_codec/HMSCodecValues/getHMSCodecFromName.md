


# getHMSCodecFromName method




    *[<Null safety>](https://dart.dev/null-safety)*




[HMSCodec](../../enum_hms_codec/HMSCodec-class.md) getHMSCodecFromName
([String](https://api.flutter.dev/flutter/dart-core/String-class.html) name)








## Implementation

```dart
static HMSCodec getHMSCodecFromName(String name) {
  switch (name) {
    case 'kHMSCodecH264':
      return HMSCodec.kHMSCodecH264;
    case 'kHMSCodecVP8':
      return HMSCodec.kHMSCodecVP8;

    default:
      return HMSCodec.unknown;
  }
}
```







