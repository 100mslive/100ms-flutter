


# getHMSPeerUpdateFromName method




    *[<Null safety>](https://dart.dev/null-safety)*




[HMSPeerUpdate](../../hmssdk_flutter/HMSPeerUpdate-class.md) getHMSPeerUpdateFromName
([String](https://api.flutter.dev/flutter/dart-core/String-class.html) name)








## Implementation

```dart
static HMSPeerUpdate getHMSPeerUpdateFromName(String name) {
  switch (name) {
    case 'peerJoined':
      return HMSPeerUpdate.peerJoined;
    case 'peerLeft':
      return HMSPeerUpdate.peerLeft;
    case 'peerKnocked':
      return HMSPeerUpdate.peerKnocked;
    case 'audioToggled':
      return HMSPeerUpdate.audioToggled;
    case 'videoToggled':
      return HMSPeerUpdate.videoToggled;
    case 'roleUpdated':
      return HMSPeerUpdate.roleUpdated;
    case 'defaultUpdate':
      return HMSPeerUpdate.defaultUpdate;
    default:
      return HMSPeerUpdate.defaultUpdate;
  }
}
```







