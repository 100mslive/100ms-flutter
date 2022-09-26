# demo_with_100ms_and_riverpod

A demo app using riverpod and 100ms.

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [100ms documentation](https://www.100ms.live/docs/flutter/v2/foundation/basics)
- New to riverpod [checkout](https://riverpod.dev/docs/getting_started/)

## Now we will see steps to use riverpod with 100ms
  In this example we will use riverpod as our state management library.

  ### Preview
1. For preview we have `PreviewStore` class which contains the callbacks and methods required for preview.

```dart
class PreviewStore extends ChangeNotifier
    implements HMSPreviewListener, HMSLogListener{}
```
  
  
2. We have some variables to maintain the UI state and update it based on the callbacks from sdk 

```dart
class PreviewStore extends ChangeNotifier
    implements HMSPreviewListener, HMSLogListener{

    late HMSSDKInteractor hmsSDKInteractor;
    PreviewStore() {
        hmsSDKInteractor = HMSSDKInteractor();
    }

    List<HMSVideoTrack> localTracks = [];
    HMSPeer? peer;
    HMSException? error;
    HMSRoom? room;
    bool isVideoOn = true;
    bool isAudioOn = true;
    int? networkQuality;
}
```

3. As we can see that PreviewStore extends `HMSPreviewListener` so we have to override the methods provided by `HMSPreviewListener`.
   
```dart
class PreviewStore extends ChangeNotifier
    implements HMSPreviewListener, HMSLogListener{

    @override
    void onHMSError({required HMSException error}) {}

    @override
    void onPreview({required HMSRoom room,
    required List<HMSTrack> localTracks}) {}

    @override
    void onPeerUpdate({required HMSPeer peer, 
    required HMSPeerUpdate update}) {}

    @override
    void onRoomUpdate({required HMSRoom room,
    required HMSRoomUpdate update}) {}

    @override
    void onLogMessage({required hmsLogList}) {}

    @override
    void onAudioDeviceChanged({
    HMSAudioDevice? currentAudioDevice,List<HMSAudioDevice>? 
    availableAudioDevice}) {}
}
```

4. As we call the `startPreview` method and if preview succeeds we get the `onPreview` callback from the sdk
```dart
@override
void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    this.room = room;
    for (HMSPeer each in room.peers!) {
    if (each.isLocal) {
        peer = each;
        break;
    }
    }
    List<HMSVideoTrack> videoTracks = [];
    for (var track in localTracks) {
    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        videoTracks.add(track as HMSVideoTrack);
    }
    }
    this.localTracks = videoTracks;
    notifyListeners();
}
```
  
  ### Room
  Similarly for room we have `MeetingStore` class which extends `HMSUpdateListener` for callbacks from sdk.
  
  1. Create `MeetingStore` class which has all different events associated with room.
  
```dart
class MeetingStore extends ChangeNotifier
    with WidgetsBindingObserver
    implements HMSUpdateListener, HMSActionResultListener, HMSStatsListener {}
```
  2. Create variables to update the UI based on callbacks from sdk.

```dart
class MeetingStore extends ChangeNotifier
with WidgetsBindingObserver
implements HMSUpdateListener, HMSActionResultListener, HMSStatsListener {
    late HMSSDKInteractor _hmsSDKInteractor;

    MeetingStore({required HMSSDKInteractor hmsSDKInteractor}) {
        _hmsSDKInteractor = hmsSDKInteractor;
    }

    HMSException? hmsException;

    bool isMeetingStarted = false;

    bool isVideoOn = true;

    bool isMicOn = true;

    bool reconnecting = false;

    bool reconnected = false;

    bool isRoomEnded = false;

    List<HMSRole> roles = [];

    List<HMSPeer> peers = [];

    HMSPeer? localPeer;

    List<HMSTrack> audioTracks = [];

    List<PeerTrackNode> peerTracks = [];

    HMSRoom? hmsRoom;

    int firstTimeBuild = 0;

    bool isScreenShareOn = false;

```
      
  3. We have a list of `PeerTrackNode` which contains all the peers and their current state i.e. Audio/Video state.


  4. Based on callbacks from sdk we will get the callbacks in `MeetingStore`.
 
  
## How to use PeerTrackNode model class

This model class is used to listen for changes corresponding to a peer.So that riverpod can only rebuild that particular changes.

```dart
class PeerTrackNode extends ChangeNotifier {
  HMSPeer peer;
  String uid;
  HMSVideoTrack? track;
  HMSAudioTrack? audioTrack;
  bool isOffscreen;

  PeerTrackNode({
    required this.peer,
    this.track,
    this.audioTrack,
    required this.uid,
    this.isOffscreen = true,
  });
}
```

We use the notify method to notify the peer for changes 

```dart
void notify() {
    notifyListeners();
}
```

We set the on/off screen status to stop downloading the video of off screen peer to save bandwidth.

```dart
void setOffScreenStatus(bool currentState) {
    this.isOffscreen = currentState;
    notify();
}
```
This is how you can rebuild widgets on change.
