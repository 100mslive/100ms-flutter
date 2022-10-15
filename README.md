<a href="https://100ms.live/">
<img src="https://github.com/100mslive/100ms-flutter/blob/main/assets/100ms.svg" title="100ms logo" float=center height=256>
</a>

[![Pub Version](https://img.shields.io/pub/v/hmssdk_flutter)](https://pub.dev/packages/hmssdk_flutter)
[![License](https://img.shields.io/github/license/100mslive/100ms-flutter)](https://www.100ms.live/)
[![Documentation](https://img.shields.io/badge/Read-Documentation-blue)](https://docs.100ms.live/flutter/v2/foundation/basics)
[![Discord](https://img.shields.io/discord/843749923060711464?label=Join%20on%20Discord)](https://100ms.live/discord)
[![Firebase](https://img.shields.io/badge/Download%20Android-Firebase-green)](https://appdistribution.firebase.dev/i/b623e5310929ab70)
[![TestFlight](https://img.shields.io/badge/Download%20iOS-TestFlight-blue)](https://testflight.apple.com/join/Uhzebmut)
[![Activity](https://img.shields.io/github/commit-activity/m/100mslive/100ms-flutter.svg)](https://github.com/100mslive/100ms-flutter/projects/1)
[![Register](https://img.shields.io/badge/Contact-Know%20More-blue)](https://dashboard.100ms.live/register)

# 100ms Flutter SDK 🎉

Here you will find everything you need to build experiences with video using 100ms iOS/Android SDK. Dive into our SDKs, quick starts, add real-time video, voice, and screen sharing to your web and mobile applications.

📲 Download the Sample iOS app here: <https://testflight.apple.com/join/Uhzebmut>

🤖 Download the Sample Android app here: <https://appdistribution.firebase.dev/i/b623e5310929ab70>


100ms Flutter apps are also released on the App Stores, you can download them here:

📲 iOS app on Apple App Store: <https://apps.apple.com/app/100ms-live/id1576541989>

🤖 Android app on Google Play Store: <https://play.google.com/store/apps/details?id=live.hms.flutter>

## 🚂 Setup Guide

1. Sign up on <https://dashboard.100ms.live/register> & visit the Developer tab to access your credentials.

2. Get familiarized with [Tokens & Security here](https://docs.100ms.live/flutter/foundation/security-and-tokens)

3. Complete the steps in [Auth Token Quick Start Guide](https://docs.100ms.live/flutter/guides/token)

4. Get the HMSSDK via [pub.dev](https://pub.dev/packages/hmssdk_flutter). Add the `hmssdk_flutter` to your pubspec.yaml.

## 🏃‍♀️ How to run the Sample App

The Example app can be found [here](https://github.com/100mslive/100ms-flutter/tree/main/example).

1. In project root, run `flutter pub get`
2. Change directory to `example` folder & run either `flutter build ios` OR `flutter build apk`
3. Finally, `flutter run`

The default [Example app](https://github.com/100mslive/100ms-flutter/tree/main/example) uses Provider State Management library. For other implementations please check out -

* [Bloc](https://github.com/100mslive/100ms-flutter/tree/main/sample%20apps/bloc)
* [Getx](https://github.com/100mslive/100ms-flutter/tree/main/sample%20apps/getx)
* [Riverpod](https://github.com/100mslive/100ms-flutter/tree/main/sample%20apps/riverpod)
* [Mobx](https://github.com/100mslive/100ms-flutter/tree/main/sample%20apps/mobx)



🚀 We have added explanations & recommended usage guide for different features, UI Layouts, Data Store, etc in [Example app ReadMe](https://github.com/100mslive/100ms-flutter/blob/main/example/README.md).


## ☝️ Minimum Configuration

- Support for Android API level 21 or higher
- Support for Java 8
- Support for iOS 12 or higher
- Support for Flutter 3.3.0 or higher
- Xcode 12 or higher

## 🤝 Recommended Configuration

- Android API level 29 or higher
- Java 11 or higher
- iOS 15 or higher
- Flutter 3.3.0 or higher
- Xcode 13 or higher

## 📱 Supported Devices

- The Android SDK supports Android API level 21 and higher. It is built for armeabi-v7a, arm64-v8a, x86, and x86_64 architectures.

- iPhone & iPads with iOS version 10 or higher.

## [Android Permissions](https://www.100ms.live/docs/flutter/v2/features/integration#android)

Add the following permissions in the Android AndroidManifest.xml file

```xml
<uses-feature android:name="android.hardware.camera"/>

<uses-feature android:name="android.hardware.camera.autofocus"/>

<uses-permission android:name="android.permission.CAMERA"/>

<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE"/>

<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/>

<uses-permission android:name="android.permission.RECORD_AUDIO"/>

<uses-permission android:name="android.permission.BLUETOOTH"/>

<uses-permission android:name="android.permission.INTERNET"/>

<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

## [iOS Permissions](https://www.100ms.live/docs/flutter/v2/features/integration#i-os)

Add following permissions in iOS Info.plist file

```xml
<key>NSMicrophoneUsageDescription</key>
<string>{YourAppName} wants to use your microphone</string>

<key>NSCameraUsageDescription</key>
<string>{YourAppName} wants to use your camera</string>

<key>NSLocalNetworkUsageDescription</key>
<string>{YourAppName} App wants to use your local network</string>
```

## 🧐 [Key Concepts](https://www.100ms.live/docs/flutter/v2/foundation/basics)

- `Room` - A room represents real-time audio, video session, the basic building block of the 100mslive Video SDK
- `Track` - A track represents either the audio or video that makes up a stream
- `Peer` - A peer represents all participants connected to a room. Peers can be "local" or "remote"
- `Broadcast` - A local peer can send any message/data to all remote peers in the room

## 🔐 Generating Auth Token
  
  Auth Token is used in HMSConfig instance to setup configuration.
  So you need to make an HTTP request. you can use any package we are using `http` package.
  You will get your token endpoint at your 100ms dashboard and append `api/token` to that endpoint and make an http post request.
  
  Example:

  ```dart
  http.Response response = await http.post(Uri.parse(Constant.getTokenURL),
          body: {'room_id': room, 'user_id': user, 'role': Constant.defaultRole});
  ```

  after generating the token parse it using JSON.

  ```dart
  var body = json.decode(response.body);
  String token = body['token'];
  ```

  You will need this token later explained below.

## ♻️ [Setup event listeners](https://www.100ms.live/docs/flutter/v2/features/update-listeners)

100ms SDK provides callbacks to the client app about any change or update happening in the room after a user has joined by implementing `HMSUpdateListener`. These updates can be used to render the video on the screen or to display other info regarding the room.

```dart

/// 100ms SDK provides callbacks to the client app about any change or update happening in the room after a user has joined by implementing HMSUpdateListener.
/// These updates can be used to render the video on the screen or to display other info regarding the room.
abstract class HMSUpdateListener {

  /// This will be called on a successful JOIN of the room by the user
  ///
  /// This is the point where applications can stop showing their loading state
  /// [room]: the room which was joined
  void onJoin({required HMSRoom room});

  /// This is called when there is a change in any property of the Room
  ///
  ///  [room]: the room which was joined
  ///  [update]: the triggered update type. Should be used to perform different UI Actions
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update});

  /// This will be called whenever there is an update on an existing peer
  /// or a new peer got added/existing peer is removed.
  ///
  /// This callback can be used to keep a track of all the peers in the room
  /// [peer]: the peer who joined/left or was updated
  /// [update]: the triggered update type. Should be used to perform different UI Actions
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update});

  /// This is called when there are updates on an existing track
  /// or a new track got added/existing track is removed
  ///
  /// This callback can be used to render the video on screen whenever a track gets added
  ///  [track]: the track which was added, removed or updated
  ///  [trackUpdate]: the triggered update type
  ///  [peer]: the peer for which track was added, removed or updated
  void onTrackUpdate({required HMSTrack track, required HMSTrackUpdate trackUpdate, required HMSPeer peer});

  /// This will be called when there is an error in the system
  /// and SDK has already retried to fix the error
  /// [error]: the error that occurred
  void onHMSError({required HMSException error});

  /// This is called when there is a new broadcast message from any other peer in the room
  ///
  /// This can be used to implement chat is the room
  /// [message]: the received broadcast message
  void onMessage({required HMSMessage message});

  /// This is called when someone asks for a change or role
  ///
  /// for eg. admin can ask a peer to become host from guest.
  /// this triggers this call on peer's app
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest});

  /// This is called every 1 second with a list of active speakers
  ///
  /// ## A HMSSpeaker object contains -
  ///    - peerId: the peer identifier of HMSPeer who is speaking
  ///    - trackId: the track identifier of HMSTrack which is emitting audio
  ///    - audioLevel: a number within range 1-100 indicating the audio volume
  ///
  /// A peer who is not present in the list indicates that the peer is not speaking
  ///
  /// This can be used to highlight currently speaking peers in the room
  /// [speakers] the list of speakers
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers});

  /// when network or some other error happens it will be called
  void onReconnecting();

  /// when you are back in the room after reconnection
  void onReconnected();

  /// when someone requests for track change of yours be it video or audio this will be triggered
  /// [hmsTrackChangeRequest] request instance consisting of all the required info about track change
  void onChangeTrackStateRequest({required HMSTrackChangeRequest hmsTrackChangeRequest});

  /// when someone kicks you out or when someone ends the room at that time it is triggered
  /// [hmsPeerRemovedFromPeer] it consists of info about who removed you and why.
  void onRemovedFromRoom({required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer});
  
  /// whenever a new audio device is plugged in or audio output is changed we
  /// get the onAudioDeviceChanged update
  /// This callback is only fired on Android devices. On iOS, this callback will not be triggered.
  /// - Parameters:
  ///   - currentAudioDevice: Current audio output route
  ///   - availableAudioDevice: List of available audio output devices
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice});
}

```

## 🤔 [How to listen to Track, Peer and Room updates?](https://www.100ms.live/docs/flutter/v2/features/update-listener-enums)

  The HMS SDK sends updates to the application about any change in HMSPeer, HMSTrack or HMSRoom via the callbacks in HMSUpdateListener.
  Application need to listen to the corresponding updates in onPeerUpdate, onTrackUpdate or onRoomUpdate

  The following are the different types of updates that are emitted by the SDK -

```dart
HMSPeerUpdate
  HMSPeerUpdate.peerJoined: A new peer joins the room
  HMSPeerUpdate.peerLeft: An existing peer leaves the room
  HMSPeerUpdate.roleUpdated: When peer role is changed
  HMSPeerUpdate.metadataChanged: When peer metadata changed
  HMSPeerUpdate.nameChanged: When peer name change

HMSTrackUpdate
  HMSTrackUpdate.trackAdded: A new track is added by a remote peer
  HMSTrackUpdate.trackRemoved: An existing track is removed from a remote peer
  HMSTrackUpdate.trackMuted: An existing track of a remote peer is muted
  HMSTrackUpdate.trackUnMuted: An existing track of a remote peer is unmuted
  HMSTrackUpdate.trackDegraded: When track is degraded
  HMSTrackUpdate.trackRestored: When track is restored

HMSRoomUpdate
  HMSRoomUpdate.roomMuted: When room is muted
  HMSRoomUpdate.roomUnmuted: When room is unmuted
  HMSRoomUpdate.serverRecordingStateUpdated: When server recording state is updated
  HMSRoomUpdate.browserRecordingStateUpdated: When browser recording state is changed
  HMSRoomUpdate.rtmpStreamingStateUpdated: When RTMP is started or stopped
  HMSRoomUpdate.hlsStreamingStateUpdated: When HLS is started or stopped
  HMSRoomUpdate.hlsRecordingStateUpdated: When hls recording state is updated
```
  
## 🛤 How to know the type and source of Track?

  HMSTrack contains a field called source which denotes the source of the Track.
  Source can have the following values - regular (normal), screen (for screenshare)and plugin (for plugins)

  To know the type of track, check the value of type which would be one of the enum values - AUDIO or VIDEO
  
## 🤝 Provide joining configuration

To join a room created by following the steps described in the above section, clients need to create an `HMSConfig` instance and use that instance to call the `join` method of `HMSSDK`

```dart
// Create a new HMSConfig
HMSConfig config = HMSConfig(authToken: token,
                            userName: userName);
```

 `token`:  follow the above step 1 to generate a token.
 `userName`: your name using which you want to join the room.

## 🙏 [Join a room](https://www.100ms.live/docs/flutter/v2/features/join)

Use the HMSConfig and HMSUpdateListener instances to call the join method on the instance of HMSSDK created above.
Once Join succeeds, all the callbacks keep coming on every change in the room and the app can react accordingly

```dart
HMSSDK hmsSDK = HMSSDK()
hmsSDK.build()
hmsSDK.joinMeeting(config: this.config);
```

## 👋 [Leave Room](https://www.100ms.live/docs/flutter/v2/features/leave)

Call the leave method on the HMSSDK instance

```dart
hmsSDK.leave() // to leave a room
```
  
## 🙊 [Mute/Unmute Local Audio](https://www.100ms.live/docs/flutter/v2/features/mute)
  
```dart
// Turn on
hmsSDK.switchAudio(isOn: true)

// Turn off  
hmsSDK.switchAudio(isOn: false)
```

## 🙈 [Mute/Unmute Local Video](https://www.100ms.live/docs/flutter/v2/features/mute)  
  
```dart  
hmsSDK.startCapturing()

hmsSDK.stopCapturing()

hmsSDK.switchCamera()
```
  
## 🛤 HMSTracks Explained
  
`HMSTrack` is the super-class of all the tracks that are used inside `HMSSDK`. Its hierarchy looks like this -
  
```dart
HMSTrack
    - AudioTrack
        - LocalAudioTrack
        - RemoteAudioTrack
    - VideoTrack
        - LocalVideoTrack
        - RemoteVideoTrack
```
  
## 🎞 [Display a Track](https://www.100ms.live/docs/flutter/v2/features/render-video)

  To display a video track, first get the `HMSVideoTrack` & pass it on to `HMSVideoView` using `setVideoTrack` function. Ensure to attach the `HMSVideoView` to your UI hierarchy.

```dart
HMSVideoView(track: videoTrack);
```

## 🔁 [Change a Role](https://www.100ms.live/docs/flutter/v2/features/change-role)

  To change role, you will provide the selected peer and new roleName from roles. If forceChange is true, the system will prompt the user for the change. If forceChange is false, the user will get a prompt to accept/reject the role.
  After changeRole is called, HMSUpdateListener's onRoleChangeRequest will be called on selected user's end.

```dart
 hmsSDK.changeRole(peer: peer, roleName: roleName, forceChange: true);
```

## 📨 [Chat Messaging](https://www.100ms.live/docs/flutter/v2/features/chat)

You can send a chat or any other kind of message from a local peer to all remote peers in the room.

To send a message first create an instance of `HMSMessage` object.

Add the information to be sent in the `message` property of `HMSMessage`.

Then use the `sendBroadcastMessage` function on the instance of HMSSDK for broadcast message, `sendGroupMessage` for group message and `sendDirectMessage` for direct message.

When you(the local peer) receives a message from others(any remote peer), `void onMessage({required HMSMessage message})` function of `HMSUpdateListener` is invoked.
  
```dart
// following is an example implementation of chat messaging

String message = 'Hello World!'

// to send a broadcast message
hmsSDK.sendBroadcastMessage(                               // hmsSDK is an instance of `HMSSDK` object
        message: message,
        hmsActionResultListener: hmsActionResultListener);  

// to send a group message
hmsSDK.sendGroupMessage(
        message: message,
        hmsRolesTo: hmsRolesTo,
        hmsActionResultListener: hmsActionResultListener);
        
// to send a direct message
hmsSDK.sendDirectMessage(
        message: message,
        peerTo: peerTo,
        hmsActionResultListener: hmsActionResultListener);


// receiving messages
// the object conforming to `HMSUpdateListener` will be invoked with `on(message: HMSMessage)`, add your logic to update Chat UI within this listener
void onMessage({required HMSMessage message}){
    let messageReceived = message.message // extract message payload from `HMSMessage` object that is received
    // update your Chat UI with the messageReceived
}
```

 🏃‍♀️ Checkout the sample implementation in the [Example app folder](https://github.com/100mslive/100ms-flutter/tree/main/example).

## 🎞 [Preview](https://www.100ms.live/docs/flutter/v2/features/preview)

  You can use our preview feature to unmute/mute audio/video before joining the room.
  
  You can implement your own preview listener using this `abstract class HMSPreviewListener`

```dart
abstract class HMSPreviewListener {

  // when an error is caught [onError] will be called
  //
  // - Parameters:
  //   - error: error which you get.
  void onHMSError({required HMSException error});

  // when you want to preview listen to this callback
  //
  // - Parameters:
  //   - room: the room which was joined
  //   - localTracks: local audio/video tracks list
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks});

  // This is called when there is a change in any property of the Room
  //
  // To Enable [onPeerUpdate] activate Enable Room-State from dashboard under templates->Advance Settings.
  //
  // - Parameters:
  //   - room: the room which was joined
  //   - update: the triggered update type. Should be used to perform different UI Actions
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update});

  // This will be called whenever there is an update on an existing peer
  // or a new peer got added/existing peer is removed.
  //
  // To Enable [onPeerUpdate] activate Send Peer List in Room-state from dashboard under templates->Advance Settings.
  //
  // This callback can be used to keep a track of all the peers in the room
  // - Parameters:
  //   - peer: the peer who joined/left or was updated
  //   - update: the triggered update type. Should be used to perform different UI Actions
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update});

  // whenever a new audio device is plugged in or audio output is changed we
  // get the onAudioDeviceChanged update
  // This callback is only fired on Android devices. On iOS, this callback will not be triggered.
  // - Parameters:
  //   - currentAudioDevice: Current audio output route
  //   - availableAudioDevice: List of available audio output devices
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice});

}
```

📖 Read the Complete Documentation here: <https://www.100ms.live/docs/flutter/v2/guides/quickstart>

🚀 We have added explanations & recommended usage guide for different features, UI Layouts, Data Store, etc in [Example app ReadMe](https://github.com/100mslive/100ms-flutter/blob/main/example/README.md).

📲 Download the Sample iOS app here: <https://testflight.apple.com/join/Uhzebmut>

🤖 Download the Sample Android app here: <https://appdistribution.firebase.dev/i/b623e5310929ab70>
