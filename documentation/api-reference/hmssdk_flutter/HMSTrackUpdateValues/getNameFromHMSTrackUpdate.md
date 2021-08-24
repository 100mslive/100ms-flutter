


# getNameFromHMSTrackUpdate method




    *[<Null safety>](https://dart.dev/null-safety)*




[String](https://api.flutter.dev/flutter/dart-core/String-class.html) getNameFromHMSTrackUpdate
([HMSTrackUpdate](../../hmssdk_flutter/HMSTrackUpdate-class.md) hmsTrackUpdate)








## Implementation

```dart
static String getNameFromHMSTrackUpdate(HMSTrackUpdate hmsTrackUpdate) {
  switch (hmsTrackUpdate) {
    case HMSTrackUpdate.trackAdded:
      return 'trackAdded';

    case HMSTrackUpdate.trackRemoved:
      return 'trackRemoved';

    case HMSTrackUpdate.trackMuted:
      return 'trackMuted';

    case HMSTrackUpdate.trackUnMuted:
      return 'trackUnMuted';

    case HMSTrackUpdate.trackDescriptionChanged:
      return 'trackDescriptionChanged';

    case HMSTrackUpdate.trackDegraded:
      return 'trackDegraded';

    case HMSTrackUpdate.trackRestored:
      return 'trackRestored';

    case HMSTrackUpdate.defaultUpdate:
      return 'defaultUpdate';
  }
}
```







