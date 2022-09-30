<a href="https://100ms.live/">
<p align="center">
<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/logo.svg" title="100ms logo" float=center height=150 >
</p>
</a>

## HMSSDK Sample App 🚀

Clone the example app from [here](https://github.com/100mslive/100ms-flutter/tree/main).
*"example"* folder contains code relevant to the example app.

> 🔑 Note: This uses provider as the state management library

## Features in sample app

Sample application contains all the features provided by `HMSSDK`. Just to name a few:

* 🙏 Join a room
* 🎞 Join with preview
* 👋 Leave room
* 🙊 Mute/Unmute local audio
* 🙈 Mute/Unmute local video
* 🖖 Mute Audio/Video for other roles and peers
* 🎞 Display video tracks
* 🔁 Change role
* 📨 Chat messaging
* 📲 Screen share
* 🎶 Audio share
* 🔊 Audio output routing
* 🙋‍♂️ Hand Raise
* 🏃‍♀️ BRB(Be Right Back sign)
* ❌ Remove Peer
* 📡 HLS Streaming

## Sample app architecture

Sample app uses provider as it's state management library.We have created separate `changeNotifier` classes namely:

* PreviewStore for Preview
* MeetingStore for Meeting room
* PeerTrackNode for individual peers

### PreviewStore

Preview Store acts as a data store for preview page.It implements `HMSPreviewListener` and `HMSLogListener` to get their callbacks by overriding their methods.

```dart
class PreviewStore extends ChangeNotifier
    implements HMSPreviewListener, HMSLogListener {}
```

### MeetingStore

Meeting Store acts as a data store for meeting page.It implements `HMSUpdateListener`,`HMSActionResultListener` and `HMSStatsListener` to get their callbacks by overriding their methods.

```dart
class MeetingStore extends ChangeNotifier
    with WidgetsBindingObserver
    implements HMSUpdateListener, HMSActionResultListener, HMSStatsListener {}
```

### PeerTrackNode

PeerTrackNode acts as a data store for each peer.One peerTrackNode object contains info about one peer.We are using this 
so that the update related to a peer are not transmitted to other peers.It contains info about peer,track,their on screen status etc.

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
<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/app-flow-diagram.png" title="app-flow" float=center height=300>
</p>

### How example app uses the updates from SDK and update the UI efficiently without extra rebuilds

Let's see how we are handling the updates in an efficient manner to avoid extra rebuilds.This is achieved by breaking down the data store in two parts.

- Updates related to application(Meeting Store class)
- Updates related to peer(PeerTrackNode class)

<p align="center">
<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/app-breakdown.png" title="app-flow" float=center height=300>
</p>

### Application settings and meeting modes

Example app offers some settings to configure the application.Some of them are :

- Skip preview(Directly join meeting)
- Mirror Camera(To set whether to mirror local camera)
- Enable Stats(To enable webrtc stats)

<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/app-settings.png" title="app-settings" float=center height=300>

---

Example app offers various meeting modes which decides the tile orientation on the mobile screen.

<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/meeting-mode.png" title="meeting-mode" height=300>

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
<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/normal-mode.gif" title="normal-mode" height=300>
</td>
<td>
<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/active-speaker-mode.gif" title="active-speaker-mode" height=300>
</td>
<td>
<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/hero-mode.gif" title="hero-mode" height=300>
</td>
<td>
<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/audio-mode.gif" title="audio-mode" height=300>
</td>
<td>
<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/single-tile-mode.gif" title="single-tile-mode" height=300>
</td>
</tr>
</table>

Try out your own UI or use one of these.It's completely customizable.

## Deep Dive into SDK and features

`HMSSDK` object needs to be created and build method is required to be called at the earliest as:

```dart
//[appGroup] - app group name
//[preferredExtension] - preferredExtension name required  for screen and audio share
//[hmsTrackSetting] - Any specific initial track settings
HMSSDK hmsSDK = HMSSDK(
    appGroup: appGroup,
    preferredExtension: preferredExtension,
    hmsTrackSetting: trackSetting);
hmsSDK.build();
```

How this is done in example app can be found [here](https://github.com/100mslive/100ms-flutter/blob/main/example/lib/hms_sdk_interactor.dart)


Let's dive deeper into each feature and their implementation.

#### 1. Join a room

`HMSSDK` provides join room method to join the room.`join` method requires `HMSConfig` as a parameter used while joining the room.
Before calling join method it's recommended to attach the `HMSUpdateListener` So that once join is successful we can get the callbacks.`HMSUpdateListener` can be attached as follows:

```dart
//We can use this since the MeetingStore class implements 
//HMSUpdateListener
HMSSDK.addUpdateListener(listener: this);
```
Methods which needs to be overriden while implementing `HMSUpdateListener` can be found [here](https://www.100ms.live/docs/flutter/v2/features/update-listeners)

Now we are good to go for the join method.Let's look at the `HMSConfig` class first:

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

We need to pass `HMSConfig` object to the join method while joining the room.

```dart
HMSSDK.join(config: config)
```
If join is successful we will get `onJoin` callback and in case of error we will get `onHMSError` callback.So the UI can be handled accordingly.

Let's understand `onJoin` method and what is expected to be done in this callback.
So,`onJoin` callback contains the `HMSRoom` object which can be used to get the recording/streaming state of the room along with list of peers in the room.The `HMSRoom` object has following info: 

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

We can extract the peers from the  `peers` list and set it accordingly.More information about how this should be handled can be found in `onJoin` method [here](https://github.com/100mslive/100ms-flutter/blob/main/example/lib/data_store/meeting_store.dart)

#### 2. Join a room with preview

In some use cases it is required to show preview before joining the room so that the user can set the camera , audio device,mic.
HMSSDK provides `preview` method which can be called before `join`.With preview included the subsequent join request becomes faster.

The `preview` method also requires the config object similar to `join` method.Before calling `preview` it is
recommended to attach `HMSPreviewListener` So that we can get the callbacks related to preview.

```dart
//We can use this since the PreviewStore class implements 
//HMSPreviewListener
HMSSDK.addPreviewListener(listener: this);
```
Methods which needs to be overriden while implementing `HMSUpdateListener` can be found [here](https://www.100ms.live/docs/flutter/v2/features/preview-update-listeners).
After attaching `HMSPreviewListener` we are good to call `preview` method.

```dart
HMSSDK.preview(config: config);
```
Similar to `onJoin` here we have `onPreview` callback which gets called when `preview` gets succeeded and `onHMSError` in case the `preview` fails.

After preview  `join` method can be called similar to the steps mentioned above in [1](#1-join-a-room).

#### 3. Leave Room

`HMSSDK` provides `leave` method to leave the room.`leave` method
has an optional parameter `HMSActionResultListener` which provides callbacks as `onSuccess` for successful execution and 
`onException` in case of error.
More info on `HMSActionResultListener` can be found [here](https://www.100ms.live/docs/flutter/v2/features/action-result-listeners)

`leave` method can be called as:

```dart
//`this` is used here since MeetingStore already implements 
//HMSActionResultListener
HMSSDK.leave(hmsActionResultListener:this);
```

We will get `onSuccess` callback if `leave` is successful so that we can perform complete cleanup of resources and `onException` in case of error.

#### 4. Mute/Unmute local audio
 
Audio mute/unmute can be performed using `switchAudio` method
of `HMSSDK`

```dart
// [isOn] is the current audio state
HMSSDK.switchAudio(isOn: isOn);
```

#### 5. Mute/Unmute local video

Video mute/unmute can be performed using `switchVideo` method
of `HMSSDK`

```dart
// [isOn] is the current state video state
HMSSDK.switchVideo(isOn: isOn);
```

#### 6. Mute Audio/Video for other roles and peers

`HMSSDK` provides dedicated methods to mute/unmute:
- Individual peer
- Specific role

These methods will only work if the peer has permissions to mute/unmute other peer's audio/video.The permission can be checked as:

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

We can use the `changeTrackStateForRole` method to mute/unmute peers under specific role.

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

> If *roles* is passed as empty list then all the roles will get affected.

Let's turn table now what happens if remote peer wishes to mute/unmute our audio/video.

- In case when remote peer mutes our audio/video `HMSSDK` performs it automatically without asking permission
- In other case we get the `onChangeTrackStateRequest` if 
we accept the request we need to call `switchVideo` or `switchAudio` according to the request.

```dart
 @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}){}
```

How this is implemented in example app can be found [here](https://github.com/100mslive/100ms-flutter/blob/main/example/lib/data_store/meeting_store.dart)

#### 7. Display video tracks

To display video tracks `HMSSDK` provides `HMSVideoView` widget.

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

Let's understand the `ScaleType` property a bit more.The `ScaleType` property decides how much space video will take from the available space.

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

> 🔑  Note: `SCALE_ASPECT_FIT` is the default scaleType for HMSVideoView

It is always advised to stop rendering video when it is not required to save bandwidth consumption.
This is done in example app by setting the `isOffscreen` property of `PeerTrackNode` as true when the peer tile is off-screen.So that app does not download video track when the tile is off-screen.

#### 8. Change role

Consider a seminar use-case where participants(with no audio/video publish permissions) wish to ask questions.
The host(with audio/video publish permissions) can give them permission to publish audio so that they can ask questions and then revoke it after they have asked the question.`changeRole` method comes to rescue.

Peer can change a participant's role to some other role using `changeRole` method providing the peer's role must have role change permission which can be checked on 100ms dashboard.The permissions can be checked as:

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

If we get `onSuccess` callback then role change is performed successfully and we will get updates in `onPeerUpdate`.

Let's turn table now what happens if remote peer wishes to change our role.

Similar to mute/unmute request we get the `onRoleChangeRequest` as:

```dart
   @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}
```
If we accept the role change we will need to call `acceptChangeRole` method of `HMSSDK`.

```dart
//[hmsRoleChangeRequest] - the request received above needs to be passed back
HMSSDK.acceptChangeRole(
  hmsRoleChangeRequest: hmsRoleChangeRequest,
  hmsActionResultListener: this);
```

If we get `onSuccess` callback then role change is performed successfully.


#### 9. Chat messaging

Chats are one of the most important part of any conferencing or live streaming applications.`HMSSDK` provides inbuilt methods for chat as well.

There are three types of method based on whom to send message

- Broadcast Message 

When we need to send message to everyone we can use the `sendBroadcastMessage` method.

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

When we need to send message to a specific peer we can use the `sendDirectMessage` method.

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

#### 10. Screen share

`HMSSDK` offers methods to share screen for both iOS and android.

Setup required for screenshare can be found [here](https://www.100ms.live/docs/flutter/v2/features/screen-share).

To start screenshare:

```dart
HMSSDK.startScreenShare(hmsActionResultListener: this);
```

To stop screenshare:

```dart
HMSSDK.stopScreenShare(hmsActionResultListener: this);
```

If the method execution is successful we will get `onSuccess` callback So that UI can be handled accordingly.

#### 11. Audio share

Sometimes we need to share audio from our phones we can do so using the audio share feature of `HMSSDK`.

> Audio share only works on android 10+ devices.

To start audioshare:

```dart
HMSSDK.startAudioShare(hmsActionResultListener: this);
```

To stop audioshare:

```dart
HMSSDK.stopAudioShare(hmsActionResultListener: this);
```

If we only want to share device audio or only share microphone audio or both at the same time we can use the `setAudioMixingMode` method.

`setAudioMixingMode` method takes `HMSAudioMixingMode` as the parameter which has following modes:

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

#### 12. Audio output routing

> This is only supported in Android platform.

Consider a scenario where bluetooth earpodes are connected to phone but you want your friends sitting with you to also listen to the stream.So,you disconnnect the bluetooth and then audio comes from external speaker.Well gone are those days when you need to do this `HMSSDK` provides inbuilt methods to easily switch audio routing.

<p align="center">
<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/audio-device-setting.png" title="audio-device-setting" height=300>
</p>

`HMSSDK` has `switchAudioOutput` method to do so.It takes 
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

Once this is called successfully we will get the callback with new audio device in `onAudioDeviceChanged` method with currently selected audio device and list of all the available devices.

```dart
//[currentAudioDevice] - Currently selected device
//[availableAudioDevice] - List of all the available devices
@override
void onAudioDeviceChanged(
    {HMSAudioDevice? currentAudioDevice,
    List<HMSAudioDevice>? availableAudioDevice}) {}
```

More about this can be found [here](https://www.100ms.live/docs/flutter/v2/features/audio-output-routing).

#### 13. Hand Raise and BRB

Let's take the seminar case again where someone has a question so how will the host know about it,hand raise feature comes to rescue.

Suppose you are in a meeting and someone's at the door unmuting and informing or using chat to inform seems a bit 
odd,HMSSDK's BRB(Be Right Back) comes to rescue.

<p align="center">
<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/hand-raise.png" title="hand-raise" height=300>
<img src="https://github.com/100mslive/100ms-flutter/blob/851/docs-provider-app/brb.png" title="brb" height=300>
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

If `changeMetadata` is successful we will get update in `onSuccess` method so we can update our UI accordingly.

#### 14. Remove peer

`HMSSDK` provides a way to remove peer from the room.This can be done using `removePeer` method.

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

If the `removePeer` method is successful we will get `onSuccess` callback and `onPeerUpdate`.

#### 15. HLS Streaming

In today's world there are endless scenarios where a user broadcasts it's stream and thousands of user consumes it.`HMSSDK`
provides `startHLSStreaming` method to handle such scenarios where a user with publish permissions publishes the content and 
user with `hls-viewer` consumes the stream.

```dart
//[hmshlsConfig] - it's an object of HMSHLSConfig which contains meeting url variants and recording configs
hmsSDK.startHlsStreaming(
    hmshlsConfig: hmshlsConfig,
    hmsActionResultListener: this);
```

After calling `startHLSStreaming` we will get `onSuccess` callback if the method invocation is successful.It takes around 5-6 seconds for HLS to start. 

## Handling Errors

Error handling is an important part of application.`HMSSDK` has `HMSException` class for error and exceptions.

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

- `onHMSError` method of `HMSUpdateListener`

`onHMSError` callbacks is received when there is some issue with the methods like join,connection errors or errors related to SDK.

```dart
@override
void onHMSError({required HMSException error}) {
  log("onHMSError-> error: ${error.message}");
}
```

- `onException` method of `HMSActionResultListener`.This gets called when the methods which have `HMSActionResultListener` attached to them gets failed.

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
Example app shows toast for the errors which will not affect the meeting and peer is still in the room but for the other errors it shows alert dialog with an option to leave the room.

## Common Mistakes and FAQs

`HMSSDK` does not support hot reload,hot restart as of now.So to verify the intended changes please follow below steps:

1. Perform changes.
2. Leave the room.
3. Perform hot reload/restart
4. Verify the changes.

---

To verify the token which is being passed in `HMSConfig` please visit [jwt.io](https://jwt.io/). The token should contain the correct room-Id,role etc.

---

For Video rendering optimizations please follow [7](#7-display-video-tracks)

--- 

Please make sure that the application is using the same `HMSSDK` instance across the app otherwise it will not get SDK updates as expected.

---

Please ensure that `build` method is called on `HMSSDK` object before performing any other operation.

---

For more FAQs please visit [FAQ's](https://www.100ms.live/docs/flutter/v2/debugging/faq)

<p align=center>
<b> Made with ❤️ by 100ms
</b>
</p>