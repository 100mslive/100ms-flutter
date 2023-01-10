# data_store_example

This example shows the usage of `PeerTrackNode` class to unify `HMSPeer` and `HMSTrack` for a peer.
Let's have a look at the application:

https://user-images.githubusercontent.com/93931528/211479051-353b986e-66d4-497f-a8a1-c204690da47d.mov

Let's have a look at the `PeerTrackNode` class:

```dart
class PeerTrackNode {
  HMSPeer peer;
  String uid;
  HMSVideoTrack? track;
}
```

- **uid**: uid is unique id for each peer
       For normal video uid is defined as "peerId+mainVideo"
       For screen share tracks it is defined as peerId+trackId
- **peer**: peer is the HMSPeer object 
- **track**: track is the HMSVideoTrack object for the peer.

API's used in the application:

- We are using `HMSUpdateListener` methods to get room updates like onJoin, onPeerUpdate, onTrackUpdate etc. More info regarding HMSUpdateListener can be found [here](https://www.100ms.live/docs/flutter/v2/features/update-listeners)

- To leave room we are using `leave` method. More info can be found [here](https://www.100ms.live/docs/flutter/v2/features/leave)

- For getting method callbacks regarding success or failure, we are using `HMSActionResultListener` callbacks. More info can be found [here](https://www.100ms.live/docs/flutter/v2/features/action-result-listeners)