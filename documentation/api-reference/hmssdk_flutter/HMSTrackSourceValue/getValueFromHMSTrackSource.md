


# getValueFromHMSTrackSource method




    *[<Null safety>](https://dart.dev/null-safety)*




[String](https://api.flutter.dev/flutter/dart-core/String-class.html) getValueFromHMSTrackSource
([HMSTrackSource](../../hmssdk_flutter/HMSTrackSource-class.md) hmsTrackKind)








## Implementation

```dart
static String getValueFromHMSTrackSource(HMSTrackSource hmsTrackKind) {
  switch (hmsTrackKind) {
    case HMSTrackSource.kHMSTrackSourceRegular:
      return 'kHMSTrackSourceRegular';
    case HMSTrackSource.kHMSTrackSourceScreen:
      return 'kHMSTrackSourceScreen';
    case HMSTrackSource.kHMSTrackSourcePlugin:
      return 'kHMSTrackSourcePlugin';
    case HMSTrackSource.unknown:
      return '';
  }
}
```







