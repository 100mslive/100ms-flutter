


# getHMSTrackUpdateFromName method




    *[<Null safety>](https://dart.dev/null-safety)*




[HMSTrackUpdate](../../enum_hms_track_update/HMSTrackUpdate-class.md) getHMSTrackUpdateFromName
([String](https://api.flutter.dev/flutter/dart-core/String-class.html) name)








## Implementation

```dart
static HMSTrackUpdate getHMSTrackUpdateFromName(String name) {
  switch (name) {
    case 'trackAdded':
      return HMSTrackUpdate.trackAdded;
    case 'trackRemoved':
      return HMSTrackUpdate.trackRemoved;
    case 'trackMuted':
      return HMSTrackUpdate.trackMuted;
    case 'trackUnMuted':
      return HMSTrackUpdate.trackUnMuted;
    case 'trackDescriptionChanged':
      return HMSTrackUpdate.trackDescriptionChanged;
    case 'trackDegraded':
      return HMSTrackUpdate.trackDegraded;
    case 'trackRestored':
      return HMSTrackUpdate.trackRestored;
    case 'defaultUpdate':
      return HMSTrackUpdate.defaultUpdate;
    default:
      return HMSTrackUpdate.defaultUpdate;
  }
}
```







