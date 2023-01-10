# Peer Track Node Data Store Example App

This example app shows the usage of `PeerTrackNode` class to unify data available in `HMSPeer` and `HMSTrack` to draw video tiles on app UI.

100ms SDK sends updates about Peer & Track in onPeerUpdate & onTrackUpdate events. In most use-cases, it's required that an unified & updated state of Peer & Track data is always available to draw a list of video tiles.

Here's a video of this Sample app -

https://user-images.githubusercontent.com/93931528/211563965-9b42453b-17f0-46cb-b71f-901d70a83388.mp4


## Steps to Run the App

- Clone this application
- Edit the `authToken` variable in `getHMSConfig` function in `utilities.dart` file. To learn more about Creating & using Auth Tokens refer the Guide [here](https://www.100ms.live/docs/flutter/v2/guides/token).

That's it you are all set 🚀🚀🚀


## Implementation

Let's have a look at the `PeerTrackNode` class:

```dart
class PeerTrackNode {

  String uid; // the unique identifier of a node. A single Peer can publish multiple Tracks like Screenshare, Video Plugins, etc

  HMSPeer peer; // the Peer object. It's possible to have multiple PeerTrackNodes for a single Peer. For example, when the peer is doing a Screenshare, playing custom video track, etc

  HMSVideoTrack? track; // the video track object backing this node. Since audio plays automatically, we are only considering Video Tracks to build the PeerTrackNode object
}
```

- **uid**: uid is unique id for each peer
       For normal video uid is defined as "peerId+mainVideo"
       For screen share tracks it is defined as peerId+trackId
- **peer**: peer is the HMSPeer object 
- **track**: track is the HMSVideoTrack object for the peer.


## 100ms SDK API's used in this application:

- To join room we are using  `join` method. More info can be found [here](https://www.100ms.live/docs/flutter/v2/features/join).

- To leave room we are using `leave` method. More info can be found [here](https://www.100ms.live/docs/flutter/v2/features/leave).

- We are using `HMSUpdateListener` methods to get room updates like onJoin, onPeerUpdate, onTrackUpdate etc. More info regarding HMSUpdateListener can be found [here](https://www.100ms.live/docs/flutter/v2/features/update-listeners).

- For getting method callbacks regarding success or failure, we are using `HMSActionResultListener` callbacks. More info can be found [here](https://www.100ms.live/docs/flutter/v2/features/action-result-listeners).

For any Questions, feedbacks feel free to reach out to us over [Discord](https://discord.com/invite/kGdmszyzq2).
