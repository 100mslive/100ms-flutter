


# HMSVideoTrack constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSVideoTrack({[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) isDegraded = false, required [HMSTrackKind](../../enum_hms_track_kind/HMSTrackKind-class.md) kind, required [HMSTrackSource](../../enum_hms_track_source/HMSTrackSource-class.md) source, required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) trackId, required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) trackDescription})





## Implementation

```dart
HMSVideoTrack(
    {this.isDegraded = false,
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







