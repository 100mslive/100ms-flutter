# data_store_example

This example shows the usage of `PeerTrackNode` class to unify `HMSPeer` and `HMSTrack` for a peer.
Let's have a look at the application which we will get after running this example:

https://user-images.githubusercontent.com/93931528/211563965-9b42453b-17f0-46cb-b71f-901d70a83388.mp4

## Steps to run the app

- Clone the application
- Edit the `authToken` variable in `getHMSConfig` function in `utilities.dart` file.To get the temporary authToken follow the docs [here](https://www.100ms.live/docs/flutter/v2/guides/token).

That's it you are all set 🚀🚀🚀

## Implementation

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

- To join room we are using  `join` method. More info can be found [here](https://www.100ms.live/docs/flutter/v2/features/join)

- To leave room we are using `leave` method. More info can be found [here](https://www.100ms.live/docs/flutter/v2/features/leave)

- We are using `HMSUpdateListener` methods to get room updates like onJoin, onPeerUpdate, onTrackUpdate etc. More info regarding HMSUpdateListener can be found [here](https://www.100ms.live/docs/flutter/v2/features/update-listeners)

- For getting method callbacks regarding success or failure, we are using `HMSActionResultListener` callbacks. More info can be found [here](https://www.100ms.live/docs/flutter/v2/features/action-result-listeners)

Questions, queries, feedbacks feel free to reach out to us over [discord](https://discord.com/invite/kGdmszyzq2)
