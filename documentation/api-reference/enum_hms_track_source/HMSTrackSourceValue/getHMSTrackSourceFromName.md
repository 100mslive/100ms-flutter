


# getHMSTrackSourceFromName method




    *[<Null safety>](https://dart.dev/null-safety)*




[HMSTrackSource](../../enum_hms_track_source/HMSTrackSource-class.md) getHMSTrackSourceFromName
([String](https://api.flutter.dev/flutter/dart-core/String-class.html) name)








## Implementation

```dart
static HMSTrackSource getHMSTrackSourceFromName(String name) {
  switch (name) {
    case 'kHMSTrackSourceRegular':
      return HMSTrackSource.kHMSTrackSourceRegular;
    case 'kHMSTrackSourceScreen':
      return HMSTrackSource.kHMSTrackSourceScreen;
    case 'kHMSTrackSourcePlugin':
      return HMSTrackSource.kHMSTrackSourcePlugin;
    default:
      return HMSTrackSource.unknown;
  }
}
```







