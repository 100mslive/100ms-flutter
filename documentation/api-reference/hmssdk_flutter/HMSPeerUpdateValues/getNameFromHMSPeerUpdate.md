


# getNameFromHMSPeerUpdate method




    *[<Null safety>](https://dart.dev/null-safety)*




[String](https://api.flutter.dev/flutter/dart-core/String-class.html) getNameFromHMSPeerUpdate
([HMSPeerUpdate](../../hmssdk_flutter/HMSPeerUpdate-class.md) hmsPeerUpdate)








## Implementation

```dart
static String getNameFromHMSPeerUpdate(HMSPeerUpdate hmsPeerUpdate) {
  switch (hmsPeerUpdate) {
    case HMSPeerUpdate.peerJoined:
      return 'peerJoined';

    case HMSPeerUpdate.peerLeft:
      return 'peerLeft';

    case HMSPeerUpdate.peerKnocked:
      return 'peerKnocked';

    case HMSPeerUpdate.audioToggled:
      return 'audioToggled';

    case HMSPeerUpdate.videoToggled:
      return 'videoToggled';

    case HMSPeerUpdate.roleUpdated:
      return 'roleUpdated';

    case HMSPeerUpdate.defaultUpdate:
      return 'defaultUpdate';
  }
}
```







