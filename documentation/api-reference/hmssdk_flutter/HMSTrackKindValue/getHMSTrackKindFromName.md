


# getHMSTrackKindFromName method




    *[<Null safety>](https://dart.dev/null-safety)*




[HMSTrackKind](../../hmssdk_flutter/HMSTrackKind-class.md) getHMSTrackKindFromName
([String](https://api.flutter.dev/flutter/dart-core/String-class.html) name)








## Implementation

```dart
static HMSTrackKind getHMSTrackKindFromName(String name) {
  switch (name) {
    ///IOS
    case 'kHMSTrackKindAudio':
      return HMSTrackKind.kHMSTrackKindAudio;
    ///IOS
    case 'kHMSTrackKindVideo':
      return HMSTrackKind.kHMSTrackKindVideo;
    ///Android
    case 'AUDIO':
      return HMSTrackKind.kHMSTrackKindAudio;
    ///Android
    case 'VIDEO':
      return HMSTrackKind.kHMSTrackKindVideo;
    default:
      return HMSTrackKind.unknown;
  }
}
```







