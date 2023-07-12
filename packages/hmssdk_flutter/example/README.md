# HMSSDK Example App 🚀

<a href="https://100ms.live/">
<p align="center">
<img src="https://user-images.githubusercontent.com/93931528/215852257-01264905-edd4-477f-8672-bb3e0287202a.svg" title="100ms logo" float=center height=150 >
</p>
</a>

Clone the Example app provided in the repo [here](https://github.com/100mslive/100ms-flutter/tree/main).

The _"example"_ folder contains code relevant to the Example app.

The Example application contains the implementation of all the features provided by `HMSSDK` some of which are listed below

- 🙏 Join a room
- 🎞 Join with a preview
- 👋 Leave room
- 🙊 Mute/Unmute local audio
- 🙈 Mute/Unmute local video
- 🖖 Mute Audio/Video for other roles and peers
- 🎞 Display video tracks
- 🔁 Change role
- 📨 Chat messaging
- 📲 Screen share
- 🎶 Audio share
- 🔊 Audio output routing
- 🙋‍♂️ Hand Raise
- 🏃‍♀️ BRB(Be Right Back sign)
- ❌ Remove Peer
- 📡 HLS Streaming
- 📱 PIP Mode
- 🎭 Spotlight
- And many more...

## Sample app architecture

The sample app uses a provider as its state management library. We have created separate `changeNotifier` classes namely:

- PreviewStore for Preview
- MeetingStore for Meeting room
- PeerTrackNode for individual peers

### PreviewStore

Preview Store acts as a data store for the preview page. It implements `HMSPreviewListener` and `HMSLogListener` to get their callbacks by overriding their methods.

```dart
class PreviewStore extends ChangeNotifier
    implements HMSPreviewListener, HMSLogListener {}
```

### MeetingStore

Meeting Store acts as a data store for the meeting page. It implements `HMSUpdateListener`, `HMSActionResultListener` and `HMSStatsListener` to get their callbacks by overriding their methods.

```dart
class MeetingStore extends ChangeNotifier
    with WidgetsBindingObserver
    implements HMSUpdateListener, HMSActionResultListener, HMSStatsListener {}
```

### PeerTrackNode

PeerTrackNode acts as a data store for each peer. One peerTrackNode object contains info about one peer. We are using this
so that the update related to a peer is not transmitted to other peers. It contains info about peers, track, on-screen status etc.

```dart
class PeerTrackNode extends ChangeNotifier {
  HMSPeer peer;
  String uid;
  HMSVideoTrack? track;
  HMSAudioTrack? audioTrack;
  bool isOffscreen;
  int? networkQuality;
  RTCStats? stats;
}
```

## Sample app data flow

### Data flow overview

<p align="center">
<img src="https://user-images.githubusercontent.com/93931528/215852461-d9d711a4-0dad-45c7-94ce-ac3862963490.png" title="app-flow" float=center height=300>
</p>

### How example app uses the updates from SDK and updates the UI efficiently without extra rebuilds

Let's see how we are handling the updates in an efficient manner to avoid extra rebuilds. This is achieved by breaking down the data store into two parts.

- Updates related to the application(Meeting Store class)
- Updates related to peer(PeerTrackNode class)

<p align="center">
<img src="https://user-images.githubusercontent.com/93931528/215852473-1976ff80-4e51-4398-ad68-e553b6dc2cf8.png" title="app-flow" float=center height=300>
</p>

### Application settings and meeting modes

The example app offers some settings to configure the application. Some of them are :

- Skip preview(Directly join the meeting)
- Mirror Camera(To set whether to mirror local camera)
- Enable Stats(To enable webRTC stats)

<img src="https://user-images.githubusercontent.com/93931528/215852661-a6bef755-8ea0-43b0-b7e5-384d0630c184.png" title="app-settings" float=center height=300>

---

The example app offers various meeting modes which decide the tile orientation on the mobile screen.

<img src="https://user-images.githubusercontent.com/93931528/215852782-982a3a16-8a76-49a0-9224-a3b58e2f3996.png" title="meeting-mode" height=300>

Let's look at each mode one by one

<table>
<tr>
<td>
<a href="https://github.com/100mslive/100ms-flutter/blob/develop/example/lib/common/ui/organisms/grid_video_view.dart">
Normal Mode
</a>
</td>
<td>
<a href="https://github.com/100mslive/100ms-flutter/blob/develop/example/lib/common/ui/organisms/grid_video_view.dart">
Active Speaker Mode
</a>
</td>
<td>
<a href="https://github.com/100mslive/100ms-flutter/blob/develop/example/lib/common/ui/organisms/grid_hero_view.dart">
Hero Mode
</a>
</td>
<td>
<a href="https://github.com/100mslive/100ms-flutter/blob/develop/example/lib/common/ui/organisms/grid_audio_view.dart" hspace="50" >
Audio Mode
</a>
</td>
<td>
<a href="https://github.com/100mslive/100ms-flutter/blob/develop/example/lib/common/ui/organisms/full_screen_view.dart" >
Single Tile Mode
</a>
</td>
</tr>
<tr>
<td>
<img src="https://user-images.githubusercontent.com/93931528/215849993-c8684aa6-1ef0-46cd-8f9e-93ad4ca2c0e4.gif"  height="300"/>
</td>
<td>
<img src="https://user-images.githubusercontent.com/93931528/215849243-80eacf1b-20b1-4983-8fad-9a6a96a7d92c.gif" height="300"/>
<td>
<img src="https://user-images.githubusercontent.com/93931528/215849287-0448e279-1911-466a-bfef-aa381ab94916.gif"  height="300"/>
</td>
<td>
<img src="https://user-images.githubusercontent.com/93931528/215849614-3c8ba473-70ae-4038-9689-c1dbc64dd9b2.gif"  height="300"/>
</td>
<td>
<img src="https://user-images.githubusercontent.com/93931528/215849267-9433d88c-b345-4a98-834a-19e157051c82.gif" height="300"/>
</td>
</tr>
</table>

Try out your own UI or use one of these. It's completely customizable.

## Deep Dive into SDK and features

`HMSSDK` object needs to be created and the build method is required to be called at the earliest as:

```dart
HMSSDK hmsSDK = HMSSDK();
hmsSDK.build();
```

How this is done in the example app can be found [here](https://github.com/100mslive/100ms-flutter/blob/main/example/lib/hms_sdk_interactor.dart)

Let's dive deeper into each feature and its implementation.

### 1. Join a room

`HMSSDK` provides a join room method to join the room.` join` method requires `HMSConfig` as a parameter used while joining the room.

`HMSConfig` requires `authToken` which is an authentication token required to join the room. We can get auth token as below:

#### 🔑 [Get Authentication token](https://www.100ms.live/docs/flutter/v2/get-started/quickstart#fetch-token-to-join-the-room)

To join a room we need an authentication token as mentioned above. There are two methods to get the token:

#### Fetch token using room-code method(Recommended)

We can get the authentication token using room-code from meeting URL.

Let's understand the subdomain and code from the sample URL
In this URL: `http://100ms-rocks.app.100ms.live/meeting/abc-defg-hij`

- Subdomain is `100ms-rocks`
- Room code is `abc-defg-ghi`

Now to get the room-code from meeting URL we can write our own logic or use the `getCode` method from [here](https://github.com/100mslive/100ms-flutter/blob/main/example/lib/service/room_service.dart)

To generate token we will be using `getAuthTokenByRoomCode` method of `HMSSDK`. This method has `roomCode` as a required
parameter, `userId` & `endPoint` as optional parameter.

> This method should be called after calling the `build` method.

Let's checkout the implementation:

```dart
  //This returns an object of Future<dynamic> which can be either
  //of HMSException type or String? type based on whether
  //method execution is completed successfully or not

  dynamic authToken = await hmsSDK.getAuthTokenByRoomCode(roomCode: 'YOUR_ROOM_CODE');

  if(authToken is String){
    HMSConfig roomConfig = HMSConfig(
        authToken: authToken,
        userName: userName,
      );

    hmsSDK.join(config: roomConfig);
  }
  else if(authToken is HMSException){
    // Handle the error
  }
```

#### Get temporary token from dashboard

To test audio/video functionality, you need to connect to a 100ms room; please check the following steps for the same:

1. Navigate to your [100ms dashboard](https://dashboard.100ms.live/dashboard) or [create an account](https://dashboard.100ms.live/register) if you don't have one.
2. Use the `Video Conferencing Starter Kit` to create a room with a default template assigned to it to test this app quickly.
3. Go to the [Rooms page](https://dashboard.100ms.live/rooms) in your dashboard, click on the `Room Id` of the room you created above, and click on the `Join Room` button on the top right.
4. In the Join with SDK section you can find the `Auth Token for role` ; you can click on the 'copy' icon to copy the authentication token.

> Token from 100ms dashboard is for testing purposes only, For production applications you must generate tokens on your own server.
> Refer to the [Management Token section](/flutter/v2/foundation/security-and-tokens#management-token) in Authentication and Tokens guide for more information.

Now we have the authentication token ready.

Before calling the join method it's recommended to attach the `HMSUpdateListener` So that once the join is successful we can get the callbacks.`HMSUpdateListener` can be attached as follows:

Methods that need to be overridden while implementing `HMSUpdateListener` can be found [here](https://www.100ms.live/docs/flutter/v2/features/update-listeners)

Now we are good to go for the join method. Let's look at the `HMSConfig` class first:

```dart
class HMSConfig {

  ///[userName] you want in the room you join.
  final String userName;

  ///[authToken] generated by 100ms servers.
  final String authToken;

  ///[metaData] any additional information you'd like to specify for the peer.
  final String? metaData;

  ///[endPoint] where you have to make post request to get token.
  final String? endPoint;

  final bool shouldSkipPIIEvents;

  ///[captureNetworkQualityInPreview] to capture the network quality in preview
  final bool captureNetworkQualityInPreview;
}
```

We need to pass the `HMSConfig` object to the join method while joining the room.

If the join is successful we will get an `onJoin` callback and in case of an error, we will get an `onHMSError` callback. So the UI can be handled accordingly.

Let's understand `onJoin` method and what is expected to be done in this callback.
So,`onJoin` callback contains the `HMSRoom` object which can be used to get the recording/streaming state of the room along with the list of peers in the room. The `HMSRoom` object has the following info:

```dart
class HMSRoom {
  ///[id] of the room
  String id;
  ///[name] the name of this room
  String? name;
  String? metaData;
  HMSBrowserRecordingState? hmsBrowserRecordingState;
  HMSRtmpStreamingState? hmsRtmpStreamingState;
  HMSServerRecordingState? hmsServerRecordingState;
  HMSHLSStreamingState? hmshlsStreamingState;
  HMSHLSRecordingState? hmshlsRecordingState;
  int peerCount;
  int startedAt;
  String sessionId;

  ///[peers] list that are present in this room currently
  final List<HMSPeer>? peers;
}
```

We can extract the peers from the `peers` list and set it accordingly. More information about how this should be handled can be found in `onJoin` method [here](https://github.com/100mslive/100ms-flutter/blob/main/example/lib/data_store/meeting_store.dart)

### 2. Join a room with a preview

In some use cases, it is required to show a preview before joining the room so that the user can set the camera, audio device, microphone etc.
HMSSDK provides a `preview` method that can be called before `join`. With a preview included the subsequent join request becomes faster.

The `preview` method also requires the config object similar to the `join` method. Before calling `preview` it is
recommended to attach `HMSPreviewListener` So that we can get the callbacks related to previewing.

Methods that need to be overridden while implementing `HMSUpdateListener` can be found [here](https://www.100ms.live/docs/flutter/v2/features/preview-update-listeners).
After attaching `HMSPreviewListener` we are good to call the `preview` method.

```dart
HMSSDK.preview(config: config);
```

Similar to `onJoin` here we have `onPreview` callback which gets called when the `preview` gets succeeded and `onHMSError` in case the `preview` fails.

After preview `join` method can be called similar to the steps mentioned above in [1](#1-join-a-room).

### 3. Leave Room

`HMSSDK` provides `leave` the method to leave the room. `leave` method has an optional parameter `HMSActionResultListener` which provides callbacks as `onSuccess` for successful execution and
`onException` in case of error.
More info on `HMSActionResultListener` can be found [here](https://www.100ms.live/docs/flutter/v2/features/action-result-listeners)

`leave` method can be called as :

```dart
//`this` is used here since MeetingStore already implements
//HMSActionResultListener
HMSSDK.leave(hmsActionResultListener:this);
```

We will get an `onSuccess` callback if `leave` is successful so that we can perform the complete cleanup of resources and `onException` in case of an error.

### 4. Mute/Unmute local audio

Audio mute/unmute can be performed using `switchAudio` method
of `HMSSDK`

```dart
// [isOn] is the current audio state
HMSSDK.switchAudio(isOn: isOn);
```

### 5. Mute/Unmute local video

Video mute/unmute can be performed using `switchVideo` method
of `HMSSDK`

```dart
// [isOn] is the current state video state
HMSSDK.switchVideo(isOn: isOn);
```

### 6. Mute Audio/Video for other roles and peers

`HMSSDK` provides dedicated methods to mute/unmute:

- Individual peer
- Specific role

These methods will only work if the peer has permission to mute/unmute another peer's audio/video. The permission can be checked as:

```dart
    //localPeer is an HMSPeer object
    localPeer?.role.permissions.mute
```

Let's look at each of them:

- Individual peer

We can use the `changeTrackState` method to mute/unmute remote peer's audio/video

```dart
// [forRemoteTrack] : track whose state needs to be changed
// Set [mute] to true if the track needs to be muted, false otherwise.
if(
    //peer has permission to change track state
    localPeer?.role.permissions.mute
  )
HMSSDK.changeTrackState(
        forRemoteTrack: forRemoteTrack,
        mute: mute,
        hmsActionResultListener: this);
```

If the `changeTrackState` method is successful we will get the `onSuccess` callback and track update in `onTrackUpdate`.

- Specific role

We can use the `changeTrackStateForRole` method to mute/unmute peers under specific roles.

```dart
// Set [mute] true if the track needs to be muted, false otherwise
  // [type] is the HMSTrackType which should be affected. If this and source are specified, it is considered an AND operation. If not specified, all track sources are affected.
  // [source] is the HMSTrackSource which should be affected. If this and type are specified, it is considered an AND operation. If not specified, all track types are affected.
  // [roles] is a list of roles, may have a single item in a list, whose tracks should be affected.
  //If not specified, all roles are affected.
  // [hmsActionResultListener] - the callback that would be called by SDK in case of a success or failure.
  /// `this` is used here since MeetingStore already implements
  if(
    //peer has permission to change track state
    localPeer?.role.permissions.mute
    )
    HMSSDK.changeTrackStateForRole(
        mute: mute,
        kind: kind,
        source: source,
        roles: roles,
        hmsActionResultListener: this);
```

If the `changeTrackStateForRole` method is successful we will get the `onSuccess` callback and track update in `onTrackUpdate` similar to `changeTrackState`.

> If _roles_ is passed as empty list then all the roles will get affected.

Let's turn the table now to what happens if a remote peer wishes to mute/unmute our audio/video.

- In case when remote peer mutes our audio/video `HMSSDK` performs it automatically without asking permission In another case, we get the `onChangeTrackStateRequest` if
  we accept the request we need to call `switchVideo` or `switchAudio` according to the request.

```dart
 @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}){}
```

How this is implemented in the example app can be found [here](https://github.com/100mslive/100ms-flutter/blob/main/example/lib/data_store/meeting_store.dart)

### 7. Display video tracks

To display video tracks `HMSSDK` provides the `HMSVideoView` widget.

```dart
class HMSVideoView extends StatelessWidget {

  //[track] - track to be displayed
  final HMSVideoTrack track;

  //[matchParent] - to match the size of parent widget
  final matchParent;

  //[scaleType] - To set the video scaling
  final ScaleType scaleType;

  //[setMirror] - To set mirroring of video
  //Generally true for local peer and false for remote peer
  final bool setMirror;
}
```

> `HMSVideoView` also accepts `Key` as an optional parameter but it is recommended to always pass `Key` to `HMSVideoView` So that it can be dispose and reset correctly during rebuilds.

Let's understand the `ScaleType` property a bit more. The `ScaleType` property decides how much space the video will take from the available space.

```dart
enum ScaleType {

  //Video maintains the aspect ratio so it only occupies space based on aspect ratio
  SCALE_ASPECT_FIT,

  //Video occupies all the available space may get cropped
  SCALE_ASPECT_FILL,

  //Video aspect ratio is balanced similar to SCALE_ASPECT_FIT
  SCALE_ASPECT_BALANCED
}
```

> 🔑 Note: `SCALE_ASPECT_FIT` is the default scaleType for HMSVideoView

It is always advised to stop rendering video when it is not required to save bandwidth consumption.
This is done in the example app by setting the `isOffscreen` property of `PeerTrackNode` as true when the peer tile is off-screen. So that app does not download the video track when the tile is off-screen.

### 8. Change role

Consider a seminar use case where participants(with no audio/video publish permissions) wish to ask questions.
The host(with audio/video publish permissions) can permit them to publish audio so that they can ask questions and then revoke it after they have asked the question.`changeRole` method comes to the rescue.

The peer can change a participant's role to some other role using `changeRole` method providing the peer's role must have role change permission which can be checked on the 100ms dashboard. The permissions can be checked as:

```dart
    //localPeer is an HMSPeer object
    localPeer?.role.permissions.changeRole
```

```dart
//[forPeer] - peer's whose role is required to be changed
//[toRole] - the role which the peer needs to be promoted
//[force] - if `true` force role change is performed while in other case user's permission is asked before role change
if(
    //peer has permission to change role
    localPeer?.role.permissions.changeRole
)
HMSSDK.changeRole(
        forPeer: forPeer,
        toRole: toRole,
        force: force,
        hmsActionResultListener: this);
```

If we get an `onSuccess` callback then the role change is performed successfully and we will get updates in `onPeerUpdate`.

Let's turn the table now on what happens if a remote peer wishes to change our role.

Similar to mute/unmute request we get the `onRoleChangeRequest` as:

```dart
   @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}
```

If we accept the role change we will need to call the `acceptChangeRole` method of `HMSSDK`.

```dart
//[hmsRoleChangeRequest] - the request received above needs to be passed back
HMSSDK.acceptChangeRole(
  hmsRoleChangeRequest: hmsRoleChangeRequest,
  hmsActionResultListener: this);
```

If we get an `onSuccess` callback then role change is performed successfully.

### 9. Chat messaging

Chats are one of the most important parts of any conferencing or live-streaming application.`HMSSDK` provides inbuilt methods for a chat as well.

There are three types of methods based on whom to send a message

- Broadcast Message

When we need to send messages to everyone we can use the `sendBroadcastMessage` method.

```dart
//[message] - Message we need to send(String)
//[type] - Message type
HMSSDK.sendBroadcastMessage(
    message: message,
    type: "",
    hmsActionResultListener: this);
```

- Group Message

When we need to send messages to specific roles we can use the `sendGroupMessage` method.

```dart
//[message] - Message we need to send(String)
//[type] - Message type
//[hmsRolesTo] - List of the roles to whom message needs to be sent
HMSSDK.sendGroupMessage(
    message: message,
    hmsRolesTo: hmsRolesTo,
    type: "",
    hmsActionResultListener: this);
```

- Direct Message

When we need to send a message to a specific peer we can use the `sendDirectMessage` method.

```dart
//[message] - Message we need to send(String)
//[type] - Message type
//[peerTo] - peer to whom message needs to be sent
HMSSDK.sendDirectMessage(
    message: message,
    peerTo: peerTo,
    type: "",
    hmsActionResultListener: this);
```

To receive messages `HMSUpdateListener` has `onMessage` callback as:

```dart
@override
void onMessage({required HMSMessage message}) {}
```

To know more about chat messaging please head over to the docs [here](https://www.100ms.live/docs/flutter/v2/features/chat)

### 10. Screen share

`HMSSDK` offers methods to share screen for both iOS and android.
The setup required for screen share can be found [here](https://www.100ms.live/docs/flutter/v2/features/screen-share).

To start screen share:

```dart
HMSSDK.startScreenShare(hmsActionResultListener: this);
```

To stop screen share:

```dart
HMSSDK.stopScreenShare(hmsActionResultListener: this);
```

If the method execution is successful we will get an `onSuccess` callback So that UI can be handled accordingly.

### 11. Audio share

Sometimes we need to share audio from our phones we can do so using the audio share feature of `HMSSDK`.

> Audio share only works on android 10+ devices.

To start audio share:

```dart
HMSSDK.startAudioShare(hmsActionResultListener: this);
```

To stop audio share:

```dart
HMSSDK.stopAudioShare(hmsActionResultListener: this);
```

If we only want to share device audio or only share microphone audio or both at the same time we can use the `setAudioMixingMode` method.

`setAudioMixingMode` method takes `HMSAudioMixingMode` as the parameter which has the following modes:

```dart
enum HMSAudioMixingMode {

  //Only microphone audio
  TALK_ONLY,

  //Both device and microphone audio
  TALK_AND_MUSIC,

  //Only device audio
  MUSIC_ONLY,
  UNKNOWN }

```

`setAudioMixingMode` can be called as:

```dart
HMSSDK.setAudioMixingMode(audioMixingMode: audioMixingMode);
```

More info about audio share can be found [here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing)

### 12. Audio output routing

> This is only supported in Android platform.

Consider a scenario where Bluetooth earphones are connected to the phone but you want your friends sitting with you to also listen to the stream. So, you disconnect the Bluetooth and then the audio comes from an external speaker. Well gone are those days when you need to do this `HMSSDK` provides inbuilt methods to easily switch audio routing.

<p align="center">
<img src="https://user-images.githubusercontent.com/93931528/215852939-395e4791-937d-4538-922f-8a5b8ed87f97.png" title="audio-device-setting" height=300>
</p>

`HMSSDK` has `switchAudioOutput` method to do so. It takes
`HMSAudioDevice` as a parameter which is an enum as:

```dart
enum HMSAudioDevice {
  //Route audio to

  //External Speaker
  SPEAKER_PHONE,

  //Wired headsets or earphones
  WIRED_HEADSET,

  //Earpiece(default for calls)
  EARPIECE,

  //bluetooth headphones,earpods etc.
  BLUETOOTH,

  //Let the OS choose automatically
  AUTOMATIC,
  UNKNOWN
}
```

> The default is `AUTOMATIC` so that the audio routing can be switched as soon as you plug earphones or connect bluetooth headphones or vice versa.

`switchAudioOutput` can be called as :

```dart
if (Platform.isAndroid)
  HMSSDK.switchAudioOutput(audioDevice: audioDevice);
```

Once this is called successfully we will get the callback with the new audio device in the `onAudioDeviceChanged` method with the currently selected audio device and a list of all the available devices.

```dart
//[currentAudioDevice] - Currently selected device
//[availableAudioDevice] - List of all the available devices
@override
void onAudioDeviceChanged(
    {HMSAudioDevice? currentAudioDevice,
    List<HMSAudioDevice>? availableAudioDevice}) {}
```

More about this can be found [here](https://www.100ms.live/docs/flutter/v2/features/audio-output-routing).

### 13. Hand Raise and BRB

Let's take the seminar case again where someone has a question so how will the host know about it, hand raise feature comes to the rescue.

Suppose you are in a meeting and someone's at the door unmuting and informing or using chat to inform seems a bit odd, HMSSDK's BRB(Be Right Back) comes to rescue.

<p align="center">
<img src="https://user-images.githubusercontent.com/93931528/215853137-f3a530c8-9702-4cc5-a7af-3cd3f79924f3.png" title="hand-raise" height=300>
&nbsp; &nbsp; &nbsp; &nbsp;
<img src="https://user-images.githubusercontent.com/93931528/215853073-f5595833-b89c-4836-80c6-1744c07651fd.png" title="brb" height=300>
</p>

Hand raise and BRB feature can be implemented using HMSPeer's metadata property as:

```dart
//[metadata] : String to be sent.This needs to send in a specific way as mentioned below.
//Set isHandRaised to true for handRaise
//Set isBRBOn to true for setting BRB status on your tile
HMSSDK.changeMetadata(
        metadata:
        "{\"isHandRaised\":true,\"isBRBOn\":false}"
        , hmsActionResultListener: this);
```

If `changeMetadata` is successful we will get an update in the `onSuccess` method so we can update our UI accordingly.

### 14. Remove peer

`HMSSDK` provides a way to remove peers from the room. This can be done using the `removePeer` method.

For removing someone from the room the peer needs to have permission to remove which can be checked as:

```dart
  localPeer?.role.permissions.removeOthers
```

`removePeer` method can be called as:

```dart
if(
  //peer has permission to remove others
  localPeer?.role.permissions.removeOthers
)
//[peer] - peer whom needs to be removed
//[reason] - why peer is being removed
HMSSDK.removePeer(
    peer: peer,
    reason: "",
    hmsActionResultListener: this);
```

If the `removePeer` method is successful we will get an `onSuccess` callback and `onPeerUpdate`.

### 15. HLS Streaming

In today's world, there are endless scenarios where a user broadcasts its stream and thousands of user consumes it.`HMSSDK` provides a `startHLSStreaming` method to handle such scenarios where a user with publish permissions publishes the content and a user with `hls-viewer`` consumes the stream.

```dart
//[hmshlsConfig] - it's an object of HMSHLSConfig which contains meeting url variants and recording configs
hmsSDK.startHlsStreaming(
    hmshlsConfig: hmshlsConfig,
    hmsActionResultListener: this);
```

After calling `startHLSStreaming` we will get an `onSuccess` callback if the method invocation is successful. It takes around 5-6 seconds for HLS to start.

### 16. PIP Mode

100ms Flutter SDK provides support for creating a Picture in Picture mode experience for video calls.

PIP Mode lets the user watch the room video in a small window pinned to a corner of the screen while navigating between apps or browsing content on the main screen.

To know more about how to implement PIP mode. Please check: [PIP Mode](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)

- PIP in Android

https://user-images.githubusercontent.com/93931528/205587304-772a5dd6-ed64-4d9e-8bb5-4fc3eed83bea.mp4

- PIP in iOS

https://github.com/100mslive/100ms-flutter/assets/93931528/af331f42-fe33-4345-bf6b-e623cc2d29e8

### 17. Spotlight

Sometimes in large video conferences or webinars where numerous participants are present, spotlighting helps draw attention to a speaker, presenter, or panelist.

HMSSDK provides a way to achieve the same, here comes `HMSSessionStore`. To read more about Session store checkout our docs [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/room/session-store)

Let's see how we can spotlight a peer using session store:

- Setup the Session store using the steps mentioned in the doc above.

- Set the session metadata using `setSessionMetadataForKey` method with key as `spotlight` and value as anything unique for a particular peer so here we are using audio trackId as the unique value.

```dart
/// Here [_hmsSessionStore] is an instance of HMSSessionStore
/// Details about how to get this are mentioned in above docs: https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/room/session-store

///Setting key as spotlight and data as peer's audio track Id
///[hmsActionResultListener] is an instance of class implementing HMSActionResultListener
_hmsSessionStore?.setSessionMetadataForKey(
        key: 'spotlight', data: audioTrackId, hmsActionResultListener: this);
```

- Listen to `onKeyChanged` method for updates regarding the session store values.

The `onKeyChanged` method is a listener that allows us to receive updates about the values stored in the session. In this case, we are interested in updates related to the `spotlight` key. When we receive an update with the key as `spotlight`, it means that there is new data available to indicate which participant's video feed should be highlighted.

```dart
  @override
  void onKeyChanged({required String key, required String? value}) {
    switch (key) {
      case 'spotlight':
        //Set the peer to spotlight here
        break;
      default:
        break;
    }
  }
```

- Remove a peer from spotlight

To remove a peer from spotlight just set the `spotlight` key as null.

```dart
/// Here [_hmsSessionStore] is an instance of HMSSessionStore
/// Details about how to get this are mentioned in above docs: https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/room/session-store

///Setting key as spotlight and data as null
///[hmsActionResultListener] is an instance of class implementing HMSActionResultListener
_hmsSessionStore?.setSessionMetadataForKey(
        key: 'spotlight', data: null, hmsActionResultListener: this);
```

Checkout spotlight in action:

https://github.com/100mslive/100ms-flutter/assets/93931528/0a9df0b9-8518-4ca4-8cd3-7447a450acb8

You can check the spotlight implementation code in the example folder above.

## Handling Errors

Error handling is an important part of the application.`HMSSDK` has `HMSException` class for errors and exceptions.

```dart
///HMSException
///
///Valid Parameters according to OS:
///
///Android: id,code, message, description, action, params and isTerminal
///
///iOS: code, description, isTerminal and canRetry.
class HMSException {
  final String? id;
  final HMSExceptionCode? code;
  final String? message;
  String description;
  String action;
  Map? params;
  bool isTerminal = false;
  bool? canRetry;
```

Error codes and their description can be found [here](https://www.100ms.live/docs/flutter/v2/features/error-handling).

There are two ways in which SDK provides error callbacks as:

- `onHMSError` method of ` HMSUpdateListener``onHMSError ` callbacks is received when there is some issue with the methods like join, connection errors or errors related to SDK.

```dart
@override
void onHMSError({required HMSException error}) {
  log("onHMSError-> error: ${error.message}");
}
```

- `onException` method of `HMSActionResultListener`.This gets called when the methods which have `HMSActionResultListener` attached to them get failed.

```dart
  @override
  void onException(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}){}
```

These callbacks should be handled properly and UI should be updated accordingly.

How errors are handled in [example app](https://github.com/100mslive/100ms-flutter/blob/main/example/lib/data_store/meeting_store.dart).
Example app shows toast for the errors which will not affect the meeting and the peer is still in the room but for the other errors, it shows an alert dialog with an option to leave the room.

## Common Mistakes and FAQs

`HMSSDK` does not support hot reload, or hot restart as of now. So to verify the intended changes please follow the below steps:

1. Perform changes.
2. Leave the room.
3. Perform hot reload/restart
4. Verify the changes.

---

To verify the token which is being passed in `HMSConfig` please visit [jwt.io](https://jwt.io/). The token should contain the correct room-Id, role etc.

---

For Video rendering optimizations please follow [7](#7-display-video-tracks)

---

Please make sure that the application is using the same `HMSSDK` instance across the app otherwise it will not get SDK updates as expected.

---

Please ensure that the `build` method is called on the `HMSSDK` object before performing any other operation.

---

For more FAQs please visit [FAQs](https://www.100ms.live/docs/flutter/v2/debugging/faq)

<p align=center>
<b> Made with ❤️ by 100ms
</b>
</p>
