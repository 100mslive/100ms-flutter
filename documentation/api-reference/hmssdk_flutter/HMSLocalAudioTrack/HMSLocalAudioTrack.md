


# HMSLocalAudioTrack constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSLocalAudioTrack({required [HMSAudioTrackSetting](../../hmssdk_flutter/HMSAudioTrackSetting-class.md) setting, required [HMSTrackKind](../../hmssdk_flutter/HMSTrackKind-class.md) kind, required [HMSTrackSource](../../hmssdk_flutter/HMSTrackSource-class.md) source, required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) trackId, required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) trackDescription})





## Implementation

```dart
HMSLocalAudioTrack(
    {required this.setting,
    required HMSTrackKind kind,
    required HMSTrackSource source,
    required String trackId,
    required String trackDescription})
    : super(
        kind: kind,
        source: source,
        trackDescription: trackDescription,
        trackId: trackId,
      );
```







