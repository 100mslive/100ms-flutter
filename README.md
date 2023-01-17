[![100ms-svg](https://user-images.githubusercontent.com/93931528/205858417-8c0a0d1b-2d46-4710-9316-7418092fd3d6.svg)](https://100ms.live/)

[![Pub Version](https://img.shields.io/pub/v/hmssdk_flutter)](https://pub.dev/packages/hmssdk_flutter)
[![License](https://img.shields.io/github/license/100mslive/100ms-flutter)](https://www.100ms.live/)
[![Documentation](https://img.shields.io/badge/Read-Documentation-blue)](https://docs.100ms.live/flutter/v2/foundation/basics)
[![Discord](https://img.shields.io/discord/843749923060711464?label=Join%20on%20Discord)](https://100ms.live/discord)
[![Firebase](https://img.shields.io/badge/Download%20Android-Firebase-green)](https://appdistribution.firebase.dev/i/b623e5310929ab70)
[![TestFlight](https://img.shields.io/badge/Download%20iOS-TestFlight-blue)](https://testflight.apple.com/join/Uhzebmut)
[![Activity](https://img.shields.io/github/commit-activity/m/100mslive/100ms-flutter.svg)](https://github.com/100mslive/100ms-flutter/projects/1)
[![Register](https://img.shields.io/badge/Contact-Know%20More-blue)](https://dashboard.100ms.live/register)

# 100ms Flutter SDK 🎉

Here you will find everything you need to build experiences with video using 100ms Flutter Package. Dive into our SDKs, Quickstart Guides, add Real-Time Video, Voice, Live Streaming to your mobile applications.

📖 Read the Complete Documentation here: https://www.100ms.live/docs/flutter/v2/guides/quickstart

📲 Download the Sample iOS app here: <https://testflight.apple.com/join/Uhzebmut>

🤖 Download the Sample Android app here: <https://appdistribution.firebase.dev/i/b623e5310929ab70>


100ms Flutter apps are also released on the App Stores, you can download them here:

📲 iOS app on Apple App Store: <https://apps.apple.com/app/100ms-live/id1576541989>

🤖 Android app on Google Play Store: <https://play.google.com/store/apps/details?id=live.hms.flutter>

## 🚂 Setup Guide

1. Sign up on <https://dashboard.100ms.live/register> & visit the Developer tab to access your credentials.

2. Get familiarized with [Tokens & Security here](https://www.100ms.live/docs/flutter/v2/foundation/security-and-tokens)

3. Complete the steps in [Auth Token Quick Start Guide](https://www.100ms.live/docs/flutter/v2/guides/token)

4. Get the HMSSDK via [pub.dev](https://pub.dev/packages/hmssdk_flutter). Add the `hmssdk_flutter` to your pubspec.yaml.

📖 Do refer the Complete [Installation Guide here](https://www.100ms.live/docs/flutter/v2/features/integration).

## 🏃‍♀️ How to run the Example App

The fully fledged Example app is [available here](https://github.com/100mslive/100ms-flutter/tree/main/example).

🚀 We have added explanations & recommended usage guide for different features, UI Layouts, Data Store, etc in [Example app ReadMe](https://github.com/100mslive/100ms-flutter/blob/main/example/README.md).

To run the Example App on your system follow these steps -
1. Clone the 100ms Flutter [Github Repo](https://github.com/100mslive/100ms-flutter.git)

2. In project root, run `flutter pub get` to build the Flutter package
3. Change directory to `example` folder
4. Now, to run the app, simply execute the `flutter run` command to run the app on a connected device, or iOS simulator, or Android Emulator.
5. For running on an iOS Device (iPhone or iPad), ensure you have set the Correct Development Team in Xcode Signing & Capabilities section. 

The default [Example app](https://github.com/100mslive/100ms-flutter/tree/main/example) uses Provider State Management library. For other implementations please check out -

* [Bloc](https://github.com/100mslive/100ms-flutter/tree/main/sample%20apps/bloc)
* [Getx](https://github.com/100mslive/100ms-flutter/tree/main/sample%20apps/getx)
* [Riverpod](https://github.com/100mslive/100ms-flutter/tree/main/sample%20apps/riverpod)
* [Mobx](https://github.com/100mslive/100ms-flutter/tree/main/sample%20apps/mobx)
* [Simple QuickStart](https://github.com/100mslive/100ms-flutter/tree/main/sample%20apps/flutter-quickstart-app)


## ☝️ Minimum Configuration

- Support for Flutter 3.3.0 or above
- Support for Android API level 21 or above
- Support for Java 8 or above
- Support for iOS 12 or above
- Xcode 12 or above

## 🤝 Recommended Configuration

- Flutter 3.3.0 or above
- Android API level 32 or above
- Java 11 or above
- iOS 16 or above
- Xcode 14 or above

## 📱 Supported Devices

- The Android SDK supports Android API level 21 and above. It is built for armeabi-v7a, arm64-v8a, x86, and x86_64 architectures. Devices running Android OS 12 or above is recommended.

- iPhone & iPads with iOS version 12 or above are supported. Devices running iOS 16 or above is recommended.

## 🤖 [Android Permissions](https://www.100ms.live/docs/flutter/v2/features/integration#android)

Complete Permissions Guide is [available here](https://www.100ms.live/docs/flutter/v2/features/integration).

Add the following permissions in the Android's `AndroidManifest.xml` file -

```xml
<uses-feature android:name="android.hardware.camera"/>

<uses-feature android:name="android.hardware.camera.autofocus"/>

<uses-permission android:name="android.permission.CAMERA"/>

<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE"/>

<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/>

<uses-permission android:name="android.permission.RECORD_AUDIO"/>

<uses-permission android:name="android.permission.INTERNET"/>

<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />

<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```

## 🍎 [iOS Permissions](https://www.100ms.live/docs/flutter/v2/features/integration#i-os)

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

- `Room` A room is the basic object that 100ms SDKs return on successful connection. This contains references to peers, tracks and everything you need to render a live a/v or live streaming app.

- `Peer` A peer is the object returned by 100ms SDKs that contains all information about a user - name, role, video track etc.

- `Track` A track is a segment of media (audio/video) captured from the peer's camera and microphone. Peers in a session publish local tracks and subscribe to remote tracks from other peers.

- `Role` A role defines who can a peer see/hear, the quality at which they publish their video, whether they have permissions to publish video/screenshare, mute someone, change someone's role.
  

## ♻️ [Setup Update Listeners](https://www.100ms.live/docs/flutter/v2/features/update-listeners)

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


  /// This is called when there is a change in any property of the Room
  ///
  ///  [room]: the room which was joined
  ///  [update]: the triggered update type. Should be used to perform different UI Actions
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update});


  /// when network or some other error happens it will be called
  void onReconnecting();


  /// when you are back in the room after reconnection
  void onReconnected();


  /// This is called when someone asks for a change or role
  ///
  /// for eg. admin can ask a peer to become host from guest.
  /// this triggers this call on peer's app
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest});


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

## 🤔 [How to listen to Peer & Track updates?](https://www.100ms.live/docs/flutter/v2/features/update-listener-enums)

  The 100ms SDK sends updates to the application about any change in HMSPeer, HMSTrack, HMSRoom, etc via the callbacks in `HMSUpdateListener`.

  The methods of HMSUpdateListener are invoked to notify updates happening in the room like a peer join/leave, track mute/unmute etc.

  More information about Update Listeners is [available here](https://www.100ms.live/docs/flutter/v2/features/update-listeners).

  The following are the different types of updates that are emitted by the SDK -

```txt
HMSPeerUpdate
  .peerJoined: A new peer joins the Room
  .peerLeft: An existing peer leaves the Room
  .roleUpdated: When a peer's Role has changed
  .metadataChanged: When a peer's metadata has changed
  .nameChanged: When a peer's name has changed


HMSTrackUpdate
  .trackAdded: A new track (audio or video) is added to the Room
  .trackRemoved: An existing track is removed from the Room
  .trackMuted: A track of a peer is muted
  .trackUnMuted: A muted track of a peer was unmuted
  .trackDegraded: When track is degraded due to bad network conditions
  .trackRestored: When a degraded track is restored when optimal network conditions are available again


HMSRoomUpdate
  .roomMuted: When room is muted to due external interruption like a Phone Call
  .roomUnmuted: When a muted room is unmuted when external interruption has ended
  .serverRecordingStateUpdated: When Server recording state is updated
  .browserRecordingStateUpdated: When Browser recording state is changed
  .rtmpStreamingStateUpdated: When RTMP is started or stopped
  .hlsStreamingStateUpdated: When HLS is started or stopped
  .hlsRecordingStateUpdated: When HLS recording state is updated
```
  
## 🙏 [Join a Room](https://www.100ms.live/docs/flutter/v2/features/join)

To join and interact with others in audio or video call, the user needs to `join` a `room`.

To join a Room, your app should have -

1. User Name - The name which should be displayed to other peers in the room.
2. [Authentication Token](https://www.100ms.live/docs/flutter/v2/foundation/security-and-tokens) - The Client side Authentication Token generated by the Token Service.

You can also optionally pass these fields -

1. Track Settings - Such as joining a Room with Muted Audio or Video using the `HMSTrackSetting` object. More information is [available here](https://www.100ms.live/docs/flutter/v2/features/join#join-with-muted-audio-video).

2. User Metadata - This can be used to pass any additional metadata associated with the user using `metadata` of `HMSConfig` object. For Eg: user-id mapping at the application side. More information is available [here](https://www.100ms.live/docs/flutter/v2/advanced-features/peer-metadata-update).

More information about Joining a Room is [available here](https://www.100ms.live/docs/flutter/v2/features/join).

```dart
// create a class that implements `HMSUpdateListener` and acts as a data source for our UI
class Meeting implements HMSUpdateListener {

    late HMSSDK hmsSDK;

    Meeting() {
        initHMSSDK();
    }

    void initHMSSDK() async {
        hmsSDK = HMSSDK(); // create an instance of `HMSSDK` by invoking it's constructor
        await hmsSDK.build(); // ensure to await while invoking the `build` method
        hmsSDK.addUpdateListener(this); // `this` value corresponds to the instance implementing HMSUpdateListener
        HMSConfig config = HMSConfig(authToken: 'eyJH5c', // client-side token generated from your token service
                                userName: 'John Appleseed');
        hmsSDK.join(config: config); // Now, we are primed to join the room. All you have to do is call `join` by passing the `config` object.
    }

    ... // implement methods of HMSUpdateListener
}
```



## 🎞 [Display a Track](https://www.100ms.live/docs/flutter/v2/features/render-video)

It all comes down to this. All the setup so far has been done so that we can show live-streaming videos in our beautiful app.

100ms Flutter Package provides the `HMSVideoView` widget that renders the video on the screen.

We simply have to pass a Video Track object to the `HMSVideoView` to begin automatic rendering of Live Video Stream.

We can also optionally pass props like `key`, `scaleType`, `mirror` to customize the `HMSVideoView` widget.

```dart
HMSVideoView(
  track: videoTrack,
  key: Key(videoTrack.trackId),
),
```

More information about displaying a Video is [available here](https://www.100ms.live/docs/react-native/v2/features/render-video).


## 👋 [Leave Room](https://www.100ms.live/docs/flutter/v2/features/leave)

Once you're done with the meeting and want to exit, call leave on the HMSSDK instance that you created to join the room.

Before calling leave, remove the `HMSUpdateListener` instance as:
```dart
// updateListener is the instance of class in which HMSUpdateListener is implemented
hmsSDK.removeUpdateListener(updateListener);
```

To leave the meeting, call the `leave` method of `HMSSDK` and pass the `hmsActionResultListener` parameter to get a success callback from SDK in the `onSuccess` override method as follow.

> You will need to implement the `HMSActionResultListener` interface in a class to get `onSuccess` and `onException` callback.
>  To know about how to implement `HMSActionResultListener`  check the docs [here](https://www.100ms.live/docs/flutter/v2/features/action-result-listeners)

```dart
class Meeting implements HMSActionResultListener{
//this is the instance of class implementing HMSActionResultListener
await hmsSDK.leave(hmsActionResultListener: this);

@override
  void onSuccess(
      {HMSActionResultListenerMethod methodType = HMSActionResultListenerMethod.unknown, Map<String, dynamic>? arguments}) {
        switch (methodType) {
          case HMSActionResultListenerMethod.leave:
          // Room leaved successfully
          // Clear the local room state
          break;
          ...
        }
      }
}
```

More information about Leaving a Room is [available here](https://www.100ms.live/docs/flutter/v2/features/leave).

  
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

## 🛤 How to know the type and source of Track?

  HMSTrack contains a field called source which denotes the source of the Track.

  `Source` can have the following values -
  - `regular` For normal Audio or Video being published by peers
  - `screen` For Screenshare track whenver a peer starts Broadcasting their Screen in a Room
  - `plugin` For a custom Audio or Video plugin being used in Room

  To know the type of track, check the value of type which would be one of the enum values - `AUDIO` or `VIDEO`


## 📨 [Chat Messaging](https://www.100ms.live/docs/flutter/v2/features/chat)

You can send a chat or any other kind of message from a local peer to all remote peers in the room.

To send a message first create an instance of `HMSMessage` object.

Add the information to be sent in the `message` property of `HMSMessage`.

Then use the `sendBroadcastMessage` function on the instance of HMSSDK for broadcast message, `sendGroupMessage` for group message and `sendDirectMessage` for direct message.

When you(the local peer) receives a message from others(any remote peer), `void onMessage({required HMSMessage message})` function of `HMSUpdateListener` is invoked.

More information about Chat Messaging is [available here](https://www.100ms.live/docs/flutter/v2/features/chat).

```dart
// onMessage is HMSUpdateListener method called when a new message is received
@override
void onMessage({required HMSMessage message}) {
  //Here we will receive messages sent by other peers
}


///[message]: Message to be sent
///[type]: Message type(More about this at the end)
///[hmsActionResultListener]: instance of class implementing HMSActionResultListener
//Here this is an instance of class that implements HMSActionResultListener i.e. Meeting
hmsSDK.sendBroadcastMessage(
  message: message,
  type: type,
  hmsActionResultListener: this);


///[message]: Message to be sent
///[peerTo]: Peer to whom message needs to be sent
///[type]: Message type(More about this at the end)
///[hmsActionResultListener]: instance of class implementing HMSActionResultListener
//Here this is an instance of class that implements HMSActionResultListener i.e. Meeting
hmsSDK.sendDirectMessage(
  message: message,
  peerTo: peerTo,
  type: type,
  hmsActionResultListener: this);


///[message]: Message to be sent
///[hmsRolesTo]: Roles to which this message needs to be sent
///[type]: Message type(More about this at the end)
///[hmsActionResultListener]: instance of class implementing HMSActionResultListener
//Here this is an instance of class that implements HMSActionResultListener i.e. Meeting
hmsSDK.sendGroupMessage(
    message: message,
    hmsRolesTo: rolesToSendMessage,
    type: type,
    hmsActionResultListener: this);



@override
void onSuccess(
  {HMSActionResultListenerMethod methodType =
    HMSActionResultListenerMethod.unknown,
    Map<String, dynamic>? arguments}) {

    switch (methodType) {

      case HMSActionResultListenerMethod.sendBroadcastMessage:
      //Broadcast Message sent successfully
      break;

      case HMSActionResultListenerMethod.sendGroupMessage:
      //Group Message sent successfully
      break;

      case HMSActionResultListenerMethod.sendDirectMessage:
      //Direct Message sent successfully
      break;
      ...
    }
  }


@override
void onException(
  {HMSActionResultListenerMethod methodType =
    HMSActionResultListenerMethod.unknown,
    Map<String, dynamic>? arguments,
    required HMSException hmsException}) {

    switch (methodType) {

      case HMSActionResultListenerMethod.sendBroadcastMessage:
      // Check the HMSException object for details about the error
      break;

      case HMSActionResultListenerMethod.sendGroupMessage:
      // Check the HMSException object for details about the error
      break;

      case HMSActionResultListenerMethod.sendDirectMessage:
      // Check the HMSException object for details about the error
      break;
      ...
    }

  }
```

📖 Do refer the Complete Documentation Guide [available here](https://www.100ms.live/docs/flutter/v2/guides/quickstart).


🏃‍♀️ Checkout the Example app implementation [available here](https://github.com/100mslive/100ms-flutter/tree/main/example).

🚀 We have added explanations & recommended usage guide for different features, UI Layouts, Data Store, etc in [Example app ReadMe](https://github.com/100mslive/100ms-flutter/blob/main/example/README.md).


100ms Flutter apps are released on the App Stores, you can download them here:

📲 iOS app on Apple App Store: <https://apps.apple.com/app/100ms-live/id1576541989>

🤖 Android app on Google Play Store: <https://play.google.com/store/apps/details?id=live.hms.flutter>
