


# HMSRemoteVideoTrack constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSRemoteVideoTrack({required [HMSVideoTrackSetting](../../hmssdk_flutter/HMSVideoTrackSetting-class.md) setting, required [bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) isDegraded, required [HMSTrackKind](../../hmssdk_flutter/HMSTrackKind-class.md) kind, required [HMSTrackSource](../../hmssdk_flutter/HMSTrackSource-class.md) source, required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) trackId, required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) trackDescription})





## Implementation

```dart
HMSRemoteVideoTrack(
    {required this.setting,
    required bool isDegraded,
    required HMSTrackKind kind,
    required HMSTrackSource source,
    required String trackId,
    required String trackDescription})
    : super(
        isDegraded: isDegraded,
        kind: kind,
        source: source,
        trackDescription: trackDescription,
        trackId: trackId,
      );
```







