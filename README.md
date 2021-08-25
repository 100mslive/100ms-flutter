<p align="center" >
  <a href="https://100ms.live/">
  <img src="https://github.com/100mslive/100ms-flutter/raw/develop/100ms.svg" title="100ms logo" float=left></a>
</p>

[![Pub Version](https://img.shields.io/pub/v/hmssdk_flutter)](https://pub.dev/packages/hmssdk_flutter)
[![License](https://img.shields.io/github/license/100mslive/100ms-flutter)](https://www.100ms.live/)
[![Documentation](https://img.shields.io/badge/Read-Documentation-blue)](https://docs.100ms.live/)
[![Discord](https://img.shields.io/badge/Community-Join%20on%20Discord-blue)](https://discord.com/invite/kGdmszyzq2)
[![Register](https://img.shields.io/badge/Contact-Know%20More-blue)](https://dashboard.100ms.live/register)

# 100ms Flutter SDK 🎉

Here you will find everything you need to build experiences with video using 100ms iOS/Android SDK. Dive into our SDKs, quick starts, add real-time video, voice, and screen sharing to your web and mobile applications.

📲 Download the Sample iOS app here: https://testflight.apple.com/join/Uhzebmut

🤖 Download the Sample Android app here: https://appdistribution.firebase.dev/i/b623e5310929ab70
  
 ## 🏃‍♀️ How to run the Sample App

 1. In project root, run `flutter pub get`
 2. Change directory to `example` folder, run `flutter packages pub run build_runner build --delete-conflicting-outputs`
 3. Run either `flutter build ios` OR `flutter build apk`
 4. Finally, `flutter run`

## 🧐 Key Concepts

- `Room` - A room represents real-time audio, video session, the basic building block of the 100mslive Video SDK
- `Track` - A track represents either the audio or video that makes up a stream
- `Peer` - A peer represents all participants connected to a room. Peers can be "local" or "remote"
- `Broadcast` - A local peer can send any message/data to all remote peers in the room 


## Generating Auth Token
  
  Auth Token is used in HMSConfig instance to setup configuration.
  So you need to make an HTTP request. you can use any package we are using `http` package.
  You will get your token endpoint at your 100ms dashboard and append `api/token` to that endpoint and make an http post request.
  
  Example:

  ```dart
  http.Response response = await http.post(Uri.parse(Constant.getTokenURL),
          body: {'room_id': room, 'user_id': user, 'role': Constant.defaultRole});
  ```

  after generating token parse it using json.

  ```dart
  var body = json.decode(response.body);
  String token = body['token'];
  ```
  You will need this token later explained below.   
    
## ♻️ Setup event listeners

100ms SDK provides callbacks to the client app about any change or update happening in the room after a user has joined by implementing `HMSUpdateListener`. These updates can be used to render the video on screen or to display other info regarding the room.

```dart
abstract class HMSUpdateListener {
  /// This will be called on a successful JOIN of the room by the user
  ///
  /// This is the point where applications can stop showing its loading state
  /// - Parameter room: the room which was joined
  void onJoin({required HMSRoom room});

  /// This is called when there is a change in any property of the Room
  ///
  /// - Parameters:
  ///   - room: the room which was joined
  ///   - update: the triggered update type. Should be used to perform different UI Actions
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update});

  /// This will be called whenever there is an update on an existing peer
  /// or a new peer got added/existing peer is removed.
  ///
  /// This callback can be used to keep a track of all the peers in the room
  /// - Parameters:
  ///   - peer: the peer who joined/left or was updated
  ///   - update: the triggered update type. Should be used to perform different UI Actions
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update});

  /// This is called when there are updates on an existing track
  /// or a new track got added/existing track is removed
  ///
  /// This callback can be used to render the video on screen whenever a track gets added
  /// - Parameters:
  ///   - track: the track which was added, removed or updated
  ///   - trackUpdate: the triggered update type
  ///   - peer: the peer for which track was added, removed or updated
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer});

  /// This will be called when there is an error in the system
  ///
  /// and SDK has already retried to fix the error
  /// - Parameter error: the error that occurred
  void onError({required HMSError error});

  /// This is called when there is a new broadcast message from any other peer in the room
  ///
  /// This can be used to implement chat is the room
  /// - Parameter message: the received broadcast message
  void onMessage({required HMSMessage message});

  /// This is called when someone asks for change or role
  ///
  /// for eg. admin can ask a peer to become host from guest.
  /// this triggers this call on peer's app
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest});

  /// This is called every 1 second with list of active speakers
  ///
  ///    A HMSSpeaker object contains -
  ///    - peerId: the peer identifier of HMSPeer who is speaking
  ///    - trackId: the track identifier of HMSTrack which is emitting audio
  ///    - audioLevel: a number within range 1-100 indicating the audio volume
  ///
  /// A peer who is not present in the list indicates that the peer is not speaking
  ///
  /// This can be used to highlight currently speaking peers in the room
  /// - Parameter speakers: the list of speakers
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers});

  void onReconnecting();

  void onReconnected();
}
```

## 🤔 How to listen to Track, Peer and Room updates? 

  The HMS SDK sends updates to the application about any change in HMSPeer , HMSTrack or HMSRoom via the callbacks in HMSUpdateListener.
  Application need to listen to the corresponding updates in onPeerUpdate , onTrackUpdate or onRoomUpdate

  The following are the different types of updates that are emitted by the SDK - 
```dart
  HMSPeerUpdate
    case PEER_JOINED A new peer joins the room
    case PEER_LEFT - An existing peer leaves the room
    case BECAME_DOMINANT_SPEAKER - A peer becomes a dominant speaker
    case NO_DOMINANT_SPEAKER - There is silence in the room (No speaker is detected)
    
  HMSTrackUpdate
    case TRACK_ADDED - A new track is added by a remote peer
    case TRACK_REMOVED - An existing track is removed from a remote peer
    case TRACK_MUTED - An existing track of a remote peer is muted
    case TRACK_UNMUTED - An existing track of a remote peer is unmuted
    case TRACK_DESCRIPTION_CHANGED - The optional description of a track of a remote peer is changed
 ```
  
## 🛤 How to know the type and source of Track?

  HMSTrack contain a field called source which denotes the source of the Track. 
  Source can have the following values - regular (normal), screen (for screenshare)and plugin (for plugins)

  To know the type of track, check the value of type which would be one of the enum values - AUDIO or VIDEO
  
## 🤝 Provide joining configuration

To join a room created by following the steps described in the above section, clients need to create a `HMSConfig` instance and use that instance to call `join` method of `HMSSDK`

```dart
// Create a new HMSConfig
HMSConfig config = HMSConfig( userId: userId,
                              roomId: roomId,
                              authToken: token,
                              userName: userName);
```
 `userId`: should be unique we are using `Uuid` package to generate one.
 `roomId`: id of the room which you want to join.
 `token`:  follow the above step 1 to generate token.
 `userName`: your name using which you want to join the room.   

## 🙏 Join a room

Use the HMSConfig and HMSUpdateListener instances to call the join method on the instance of HMSSDK created above.
Once Join succeeds, all the callbacks keep coming on every change in the room and the app can react accordingly

```dart
HMSMeeting meeting = HMSMeeting()
meeting.joinMeeting(config: this.config);
```

## 👋 Leave Room

Call the leave method on the HMSSDK instance

```dart
meeting.leave() // to leave a room
```
  
## 🙊 Mute/Unmute Local Audio
  
```dart
// Turn on
meeting.switchAudio(isOn:true)
// Turn off  
meeting.switchAudio(isOn:false)
```

## 🙈 Mute/Unmute Local Video  
  
```dart  
meeting.startCapturing()

meeting.stopCapturing()

meeting.switchCamera()
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
  
## 🎞 Display a Track
  To display a video track, first get the `HMSVideoTrack` & pass it on to `HMSVideoView` using `setVideoTrack` function. Ensure to attach the `HMSVideoView` to your UI hierarchy.

  ```dart
  VideoView(
      track: videoTrack,
      args: {
        'height': customHeight,
        'width': customWidth,
      },
    );
  ```

## Change a Role
  To change role, you will provide peerId of selected peer and new roleName from roles. If forceChange is true, the system will prompt user for the change. If forceChange is false, user will get a prompt to accept/reject the role.
  After changeRole is called, HMSUpdateListener's onRoleChangeRequest will be called on selected user's end.
```dart
 meeting.changeRole(
        peerId: peerId, roleName: roleName, forceChange: forceChange);
```

## 📨 Chat Messaging
You can send a chat or any other kind of message from local peer to all remote peers in the room.

To send a message first create an instance of `HMSMessage` object.

Add the information to be sent in the `message` property of `HMSMessage`.

Then use the `  Future<void> sendMessage(String message)` function on instance of HMSMeeting.

When you(the local peer) receives a message from others(any remote peer), `  void onMessage({required HMSMessage message})` function of `HMSUpdateListener` is invoked.
  
```dart
// following is an example implementation of chat messaging

// to send a broadcast message
String message = 'Hello World!'
meeting.sendMessage(message);  // meeting is an instance of `HMSMeeting` object



// receiving messages
// the object conforming to `HMSUpdateListener` will be invoked with `on(message: HMSMessage)`, add your logic to update Chat UI within this listener
void onMessage({required HMSMessage message}){
    let messageReceived = message.message // extract message payload from `HMSMessage` object that is received
    // update your Chat UI with the messageReceived
}
```

 🏃‍♀️ Checkout the sample implementation in the [Example app folder](https://github.com/100mslive/100ms-flutter/tree/main/example).

## 🎞 Preview
  You can use our preview feature to unmute/mute audio/video before joining the room.
  
  You can implement your own preview listener using this `abstract class HMSPreviewListener`

```dart 
abstract class HMSPreviewListener {

  //you will get all error updates here
  void onError({required HMSError error});

  //here you will get room instance where you are going to join and your own local tracks to render the video by checking the type of trackKind and then using the 
  //above mentioned VideoView widget
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks});
}
```


## 🚂 Setup Guide

1. Sign up on https://dashboard.100ms.live/register & visit the Developer tab to access your credentials.

2. Get familiarized with [Tokens & Security here](https://docs.100ms.live/ios/v2/foundation/Security-and-tokens)

3. Complete the steps in [Auth Token Quick Start Guide](https://docs.100ms.live/ios/v2/guides/Token)

4. Get the HMSSDK via [pub.dev](https://pub.dev/). Add the `hmssdk_flutter` to your pubspec.yaml



## Android Integration

Add following permissions in Android AndroidManifest.xml file

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
```

## ☝️ Pre-requisites

- Support for Android API level 24 or higher
- Support for Java 8

## 📱 Supported Devices

The Android SDK supports Android API level 21 and higher. It is built for armeabi-v7a, arm64-v8a, x86, and x86_64 architectures.

## iOS Integration


Add following permissions in iOS Info.plist file
```xml
<key>NSMicrophoneUsageDescription</key>
<string>{YourAppName} wants to use your microphone</string>

<key>NSCameraUsageDescription</key>
<string>{YourAppName} wants to use your camera</string>

<key>NSLocalNetworkUsageDescription</key>
<string>{YourAppName} App wants to use your local network</string>
```
