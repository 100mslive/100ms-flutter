


# getValueFromHMSTrackKind method




    *[<Null safety>](https://dart.dev/null-safety)*




[String](https://api.flutter.dev/flutter/dart-core/String-class.html) getValueFromHMSTrackKind
([HMSTrackKind](../../enum_hms_track_kind/HMSTrackKind-class.md) hmsTrackKind)








## Implementation

```dart
static String getValueFromHMSTrackKind(HMSTrackKind hmsTrackKind) {
  switch (hmsTrackKind) {
    case HMSTrackKind.kHMSTrackKindAudio:
      return 'kHMSTrackKindAudio';
    case HMSTrackKind.kHMSTrackKindVideo:
      return 'kHMSTrackKindVideo';
    case HMSTrackKind.unknown:
      return '';
  }
}
```







