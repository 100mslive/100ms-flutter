# Latest Versions

| Package        | Version                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------ |
| hms_room_kit   | [![Pub Version](https://img.shields.io/pub/v/hms_room_kit)](https://pub.dev/packages/hms_room_kit)     |
| hmssdk_flutter | [![Pub Version](https://img.shields.io/pub/v/hmssdk_flutter)](https://pub.dev/packages/hmssdk_flutter) |

# 1.10.3 - 2024-06-12

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.1.3  |
| hmssdk_flutter              | 1.10.3 |

Uses Android SDK 2.9.59 & iOS SDK 1.12.0

**Full Changelog**: [1.10.2...1.10.3](https://github.com/100mslive/100ms-flutter/compare/1.10.2...1.10.3)

# 1.10.2 - 2024-05-15

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.1.2  |
| hmssdk_flutter              | 1.10.2 |

### ✨ Added

- Introducing Whiteboard support in HMSSDK

  HMSSDK now provides support for Whiteboard. You can now start/stop a whiteboard using `HMSWhiteboardController` methods. HMSSDK provides also provides callbacks for whiteboard start/stop events. Learn more about it [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/whiteboard)

- HLS Layer methods

  HLS Stream Layers can be controlled using the HMSHLSPlayerController's `getHLSLayers` and `setHLSLayer` methods. Learn more about the methods [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player)

- `onPeerListUpdate` event on `HMSPreviewListener`

  The `onPeerListUpdate` event is now available on `HMSPreviewListener` to get updates on the peer list. Learn more about it [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/preview#supplementary-bytes)

Uses Android SDK 2.9.56 & iOS SDK 1.10.0

**Full Changelog**: [1.10.1...1.10.2](https://github.com/100mslive/100ms-flutter/compare/1.10.1...1.10.2)

# 1.10.1 - 2024-04-26

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.1.1 |
| hmssdk_flutter              | 1.10.1 |

### ✨ Added

- Support for captions in HLS Player

  HMSSDK now provides support for captions in HLS Player. You can now `enable` or `disable` captions in the HLS Player using the 
  `HMSHLSPlayerController` methods. Moreover HMSSDK provides a new `onCues` callback to get captions. Learn more about it [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-enabledisable-captions)

Uses Android SDK 2.9.54 & iOS SDK 1.9.0

**Full Changelog**: [1.10.0...1.10.1](https://github.com/100mslive/100ms-flutter/compare/1.10.0...1.10.1)

# 1.10.0 - 2024-04-22

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.1.0 |
| hmssdk_flutter              | 1.10.0 |

### ✨ Added

- Noise Cancellation Integration

  You can enhance your app's audio quality with the newly integrated Noise Cancellation feature in HMSSDK. With this addition, control Noise Cancellation settings through the `HMSNoiseCancellationController`

  Learn more about leveraging this capability in your app by checking the documentation [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/noise-cancellation).
  
- [SIP](https://www.100ms.live/docs/server-side/v2/how-to-guides/Session%20Initiation%20Protocol%20(SIP)/SIP-Interconnect) Capability

  HMSSDK now offers a way to differentiate between SIP and non-SIP users in the Room. You can use the `type` property in the `HMSPeer` class to check if a peer is a SIP user.

  Learn more about SIP Capabilities [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/sip).

### 🛠️ Changed

- `HMSHLSPlayer` now uses Hybrid Composition on Android for better performance.

Uses Android SDK 2.9.54 & iOS SDK 1.8.0

**Full Changelog**: [1.9.14...1.10.0](https://github.com/100mslive/100ms-flutter/compare/1.9.14...1.10.0)

# 1.9.14 - 2024-04-01

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.0.17  |
| hmssdk_flutter              | 1.9.14  |

### 🛠️ Fix

- Resolved an issue on iOS where the video appears stretched in landscape mode

Uses Android SDK 2.9.51 & iOS SDK 1.8.0

**Full Changelog**: [1.9.13...1.9.14](https://github.com/100mslive/100ms-flutter/compare/1.9.13...1.9.14)

# 1.9.13 - 2024-03-15

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.0.16  |
| hmssdk_flutter              | 1.9.13  |

### ✨ Added

- Leave Room Immediately if App is Killed(iOS only)

  - HMSSDK automatically triggers `leave` method call when the iOS application is terminated.

Updated to Android SDK 2.9.51 & iOS SDK 1.6.0

**Full Changelog**: [1.9.12...1.9.13](https://github.com/100mslive/100ms-flutter/compare/1.9.12...1.9.13)


# 1.9.12 - 2024-03-04

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.0.15  |
| hmssdk_flutter              | 1.9.12  |

### ✨ Added

- Introducing methods to fetch polls, questions, leaderboards and results

  - Users can now fetch polls based on the poll state, questions for a poll and poll results
    using the `fetchPollList`, `fetchPollQuestions` and `getPollResults` methods.
    Checkout the docs [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/room/polls#fetchpolllist)

Updated to iOS SDK 1.6.0

**Full Changelog**: [1.9.11...1.9.12](https://github.com/100mslive/100ms-flutter/compare/1.9.11...1.9.12)

# 1.9.11 - 2024-02-26

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.0.14  |
| hmssdk_flutter              | 1.9.11  |

### ✨ Added

- Introducing leaderboard APIs

  - Users can now fetch rankings and quiz summary using the `fetchLeaderboard` method. More information about leaderboard can be found [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/room/polls)

Updated to Android SDK 2.9.4 & iOS SDK 1.5.1

**Full Changelog**: [1.9.10...1.9.11](https://github.com/100mslive/100ms-flutter/compare/1.9.10...1.9.11)

# 1.9.10 - 2024-02-16

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.0.13  |
| hmssdk_flutter              | 1.9.10   |

### ✨ Added

- Introducing Quizzes

  - Users can now seamlessly create, answer, and manage quizzes using HMSSDK.

**Full Changelog**: [1.9.9...1.9.10](https://github.com/100mslive/100ms-flutter/compare/1.9.9...1.9.10)

# 1.9.9 - 2024-02-12

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.0.12  |
| hmssdk_flutter              | 1.9.9   |

### ✨ Added

- Introducing Polls

  - APIs for Comprehensive Poll Management:
    - `quickStartPoll` to start polls
    - `addSingleChoicePollResponse` & `addMultiChoicePollResponse` for adding single and multi choice response
    - `stopPoll` to stop polls

  - Poll Update Listeners for Real-Time Notifications:
    - Use `addPollUpdateListener` to start listening to poll updates
    - Use `removePollUpdateListener` to stop listening to poll updates

  - Enhanced Poll Permissions within `HMSPermissions`:
    - `pollRead` property ensures controlled read access to poll results and details.
    - `pollWrite` property enables secure write access, allowing for poll creation and response submission.

Updated to Android SDK 2.9.0 & iOS SDK 1.5.0

**Full Changelog**: [1.9.8...1.9.9](https://github.com/100mslive/100ms-flutter/compare/1.9.8...1.9.9)

# 1.9.8 - 2024-02-01

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.0.11  |
| hmssdk_flutter              | 1.9.8   |

### 🛠️ Changed

- Fixed broadcast receiver issues on android 14 devices

  Learn more about this issue [here](https://developer.android.com/about/versions/14/behavior-changes-14#runtime-receivers-exported)

**Full Changelog**: [1.9.7...1.9.8](https://github.com/100mslive/100ms-flutter/compare/1.9.7...1.9.8)

# 1.9.7 - 2024-01-18

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.0.10  |
| hmssdk_flutter              | 1.9.7   |

Updated to Android SDK 2.8.8 & iOS SDK 1.4.2

**Full Changelog**: [1.9.6...1.9.7](https://github.com/100mslive/100ms-flutter/compare/1.9.6...1.9.7)

# 1.9.6 - 2024-01-15

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.0.9  |
| hmssdk_flutter              | 1.9.6  |

### ✨ Added

- Added `isLargeRoom` property in `HMSRoom` class to check whether the current room is a large room or not

### 🔄 Changed

- `setSessionMetadataForKey` method now supports `dynamic` type for `data` parameter instead of `String?` type.

  Learn more about Session Store [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/room/session-store#setting-a-value-for-a-specific-key).

Updated to Android SDK 2.8.5 & iOS SDK 1.4.1

**Full Changelog**: [1.9.5...1.9.6](https://github.com/100mslive/100ms-flutter/compare/1.9.5...1.9.6)

# 1.9.5 - 2023-12-15

| Package                                | Version                                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| hms_room_kit                | 1.0.8  |
| hmssdk_flutter              | 1.9.5  |

### Added 

- Added `state` property to recording and streaming classes to get the current state of recording and streaming.

  Learn more about `HMSStreamingState` and `HMSRecordingState` [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/recording#current-room-status).

### Changed

- Removed `addTrackByDefault` property from `HMSTextureView`. 

  This should not affect any existing implementation as `addTrackByDefault` was set to `true` by default.
  Learn more about `HMSTextureView` [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/render-video/hms-texture-view).

Updated to Android SDK 2.8.3 & iOS SDK 1.4.0

**Full Changelog**: [1.9.4...1.9.5](https://github.com/100mslive/100ms-flutter/compare/1.9.4...1.9.5)

# 1.9.4 - 2023-12-08

| Package        | Version                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------ |
| hms_room_kit   | 1.0.7     |
| hmssdk_flutter | 1.9.4     |

### Added

- Added `HMSTextureView` for improved performance of video rendering on Android devices. This is an alternative to `HMSVideoView` which is based on `SurfaceView`.

  Learn more about `HMSTextureView` [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/render-video/hms-texture-view).

Updated to Android SDK 2.8.3 & iOS SDK 1.3.1

**Full Changelog**: [1.9.3...1.9.4](https://github.com/100mslive/100ms-flutter/compare/1.9.3...1.9.4)

## 1.9.3 - 2023-11-17

### Added

- Added `Subscriber Stats` for improved debugging of subscription issues.

Updated to Android SDK 2.8.1 & iOS SDK 1.3.0

**Full Changelog**: [1.9.2...1.9.3](https://github.com/100mslive/100ms-flutter/compare/1.9.2...1.9.3)

## 1.9.2 - 2023-11-09

### Changed

- Auto simulcast in `HMSVideoView` correctly picks the layers based on the size of the view.

- Resolved an issue where after a Call Interruption the voices of users were robotic

- Removed default usage of Software Echo Cancellation. Now, by default Hardware echo cancellation will be used. More information is available [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/configure-your-device/microphone/echo-cancellation)

Updated to Android SDK 2.8.0 & iOS SDK 1.2.0

**Full Changelog**: [1.9.1...1.9.2](https://github.com/100mslive/100ms-flutter/compare/1.9.1...1.9.2)

## 1.9.1 - 2023-11-02

### Fixed

- Fixed a bug where `peerLeft` was not getting fired even in case of a broadcaster.

Updated to Android SDK 2.7.9 & iOS SDK 1.1.0

**Full Changelog**: [1.9.0...1.9.1](https://github.com/100mslive/100ms-flutter/compare/1.9.0...1.9.1)

## 1.9.0 - 2023-10-16

### Added

- Large Room Support

  - Added first class "Hand Raise" apis: `raiseLocalPeerHand`, `lowerLocalPeerHand`, `lowerRemotePeerHand`
  - Added `onPeerListUpdate` event on `HMSUpdateListener`, This requires overriding the `onPeerListUpdate` method in all implementations of HMSUpdateListener.
  - Added "Peer List Iterator" APIs - `getPeerListIterator`

  For more details refer [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/peer/large-room)

- Added `isHandRaised` property on `HMSPeer` class instance

- Added `initialising` property on `HMSBrowserRecordingState` class instance

Updated to Android SDK 2.7.7 & iOS SDK 1.1.0

**Full Changelog**: [1.8.0...1.9.0](https://github.com/100mslive/100ms-flutter/compare/1.8.0...1.9.0)

## 1.8.0 - 2023-09-15

### Added

- Added `previewForRole` & `cancelPreview` APIs to preview the audio / video of a particular role before changing into the new Role.

  ```dart
  // preview video of a particular role
  await hmsSDK.previewForRole(role: "viewer-on-stage");

  // cancel preview
  await hmsSDK.cancelPreview();
  ```

  Learn more about Change Role [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/peer/change-role)

### Changed

- Starting HLS Streaming will now return an appropriate `HMSException` when any error happens to start the streaming.
  ```dart
  Future<HMSException?> startHlsStreaming(
      {HMSHLSConfig? hmshlsConfig,
      HMSActionResultListener? hmsActionResultListener})
  ```

Updated to Android SDK 2.7.6 & iOS SDK 0.9.12

**Full Changelog**: [1.7.5...1.8.0](https://github.com/100mslive/100ms-flutter/compare/1.7.5...1.8.0)

## 1.7.5 - 2023-08-18

Bug fixes and performance improvements

Updated to Android SDK 2.7.3 & iOS SDK 0.9.9

**Full Changelog**: [1.7.4...1.7.5](https://github.com/100mslive/100ms-flutter/compare/1.7.4...1.7.5)

## 1.7.4 - 2023-08-18

Bug fixes and performance improvements

Updated to Android SDK 2.7.3 & iOS SDK 0.9.9

**Full Changelog**: [1.7.3...1.7.4](https://github.com/100mslive/100ms-flutter/compare/1.7.3...1.7.4)

## 1.7.3 - 2023-08-03

### Added

- Added `toggleAlwaysScreenOn` method to enable the wakelock functionalities

  This method allows you to toggle `always screen on` mode which prevents the screen from turning off automatically.

  Read more about the `toggleAlwaysScreenOn` method [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/always-screen-on)

- Added `initialising` property in `HMSBrowserRecordingState` class

  The `initialising` property provides information whether the recording in the room is intialising

  Read more about the `HMSBrowserRecordingState` class [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/recording#current-room-status)

Updated to Android SDK 2.7.2 & iOS SDK 0.9.6

**Full Changelog**: [1.7.2...1.7.3](https://github.com/100mslive/100ms-flutter/compare/1.7.2...1.7.3)

## 1.7.2 - 2023-07-14

### Changed

- Reduced SDK & App binary size on Android by removing redundant package imports

Updated to Android SDK 2.7.1 & iOS SDK 0.9.5

**Full Changelog**: [1.7.1...1.7.2](https://github.com/100mslive/100ms-flutter/compare/1.7.1...1.7.2)

## 1.7.1 - 2023-06-30

### Added

- Added phoneCallState property in `HMSAudioTrackSetting`

  The `phoneCallState` property can be used to set the microphone state when you receive a phone call.

  Read more about the `phoneCallState` property [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/track/set-track-settings#phonecallstate-android-only).

Updated to Android SDK 2.6.8 & iOS SDK 0.9.5

**Full Changelog**: [1.7.0...1.7.1](https://github.com/100mslive/100ms-flutter/compare/1.7.0...1.7.1)

## 1.7.0 - 2023-06-20

### Breaking

- Removed Session Metadata methods

  The `setSessionMetadata` and `getSessionMetadata` methods which were deprecated in previous versions have been removed now.

  Utilize the Session Store functionality which is more convenient to implement features like Spotlight a Peer in Room, Keep a Message Pinned, etc. Read more about Session Store [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/room/session-store).

### Added

- Added HLS Player

  Introducing the 100ms HLS Player named `HMSHLSPlayer` a comprehensive end-to-end solution for playing Live Streaming content with inbuilt support for [Timed Metadata](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-get-hls-callbacks), [HLS Diagnostic Stats](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-know-the-stats-related-to-hls-playback) & [Custom Player Controls](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#hls-player-controls).

  Learn more about `HMSHLSPlayer` [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player).

- Switch Audio Output using Native iOS UI

  On iOS devices, you can now show the Native Airplay UI provided by iOS. Users can control the connected device which can be Airpods, any Bluetooth earphones, Wired Headsets, etc through which the Room's audio should be routed.

  Learn more about it [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/configure-your-device/speaker/audio-output-routing#switch-audio-output-device-ui-ios-only).

  - Added `messageId` to `HMSMessage`

  You can now uniquely identify a message using the `messageId` property of `HMSMessage` class.

  Checkout more about Messaging [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/chat#receiving-chat-messages).

### Changed

- RTMP Streaming can now be started without the `meetingUrl`. It is now an optional parameter. Learn more about RTMP Streaming [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/recording#startstop-streaming-recording).

- [Software Audio Echo Cancellation](https://www.100ms.live/docs/flutter/v2/how-to-guides/configure-your-device/microphone/echo-cancellation) is now enabled by default. To further customize Audio & Video Track Settings, refer the docs [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/track/set-track-settings).

- On Android, Screen share from a remote peer will now appear correctly occupy the space provided by the enclosing widget. Read more about Screen Share [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/screen-share).

Updated to Android SDK 2.6.7 & iOS SDK 0.9.5

**Full Changelog**: [1.6.0...1.7.0](https://github.com/100mslive/100ms-flutter/compare/1.6.0...1.7.0)

## 1.6.0 - 2023-05-04

### New Features

- Session Store
  You can now use Session Store, a shared real-time key-value store accessible by everyone in the Room. This can be used to implement new features such as Pinned Messages and Spotlight Video Tiles, which brings a particular peer to the center stage for everyone in the Room.

  Learn more about Session Store in the [documentation](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/room/session-store).

- Music Mode on iOS
  The latest update adds the ability to achieve high-quality audio recordings with full, rich sound, whether you are recording music, podcasts, or any other type of audio.

  Learn more about the [Music Mode here](https://www.100ms.live/docs/flutter/v2/how-to-guides/configure-your-device/microphone/music-mode).

### Changes

- Android version 12+: We've made changes to Android 12+ so that adding PIP declaration in the Manifest file is now optional, except for those using the PIP Feature.

  Check out more in the [Picture-in-Picture (PIP) documentation](https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/render-video/pip-mode).

- This version includes a significant improvement in the usability of Local Audio Share APIs. By optimizing the ergonomics, we have made it more intuitive and user-friendly for you to interact with these APIs.

  Read more about [Local Audio Share here](https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/local-audio-share).

Updated to Android SDK 2.6.2 & iOS SDK 0.9.3

**Full Changelog**: [1.5.0...1.6.0](https://github.com/100mslive/100ms-flutter/compare/1.5.0...1.6.0)

## 1.5.0 - 2023-04-21

### Breaking

- Updated Screen share and Audio share implementation in Android

  The latest update includes changes in the implementation of Screen share and Audio share on Android. If you are using Screenshare or Local Audio Share functionalities, upgrading to this version or above will require changes to be made to the `onActivityResult` method of `MainActivity.kt`.

  More details are available in the Migration Guide listed below:

  - [Screen Share Migration Guide](https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/screen-share#migrating-from-older-hmssdk-version-to-150-or-above)

  - [Audio Share Migration Guide](https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/local-audio-share#migrating-from-older-hmssdk-version-to-150-or-above)

### Added

- Camera Control Capabilities

  The latest update includes the ability to capture an image from a local peer feed at the maximum resolution supported by the Camera, and the ability to control the phone's flash (if supported).

  Read more about the [Camera Controls here](https://www.100ms.live/docs/flutter/v2/how--to-guides/configure-your-device/camera/camera-controls).

- Enter PIP Mode automatically

  The new update allows for automatic entry into PIP mode for all Android versions upon minimizing the application.

  Read more about adding [PIP Mode here](https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/pip-mode).

### Changed

- Improved logging capabilities in SDK for a more efficient and streamlined logging process.

  Read more about using [Logging here](https://www.100ms.live/docs/flutter/v2/how--to-guides/debugging/error-logging).

Updated to Android SDK 2.6.1 & iOS SDK 0.9.2

Full Changelog: [1.4.0...1.5.0](https://github.com/100mslive/100ms-flutter/compare/1.4.0...1.5.0)

## 1.4.0 - 2023-04-06

### Added

- Join using Room Codes

  - Room Codes is a streamlined and secure way to manage user authentication in Rooms.
  - By generating short codes via `getAuthTokenByRoomCode` API, you can easily manage user access with one code per role for each room, without the need for server infrastructure
  - This feature ensures a smoother login experience for users while enhancing security.

  You can read more about Room Codes [here](https://www.100ms.live/docs/concepts/v2/concepts/rooms/room-codes/room-codes).

### Changed

- Improved Logging capabilities to help you diagnose and debug performance and user-reported issues more effectively

Updated to Android SDK 2.6.0 & iOS SDK 0.9.1

Full Changelog: [1.3.3...1.4.0](https://github.com/100mslive/100ms-flutter/compare/1.3.3...1.4.0)

## 1.3.3 - 2023-03-22

### Fixed

- Fixed an issue in Android PIP Mode wherein the PIP window showed black tile if the device is locked and then unlocked

- Android PIP window will now automatically close if the Peer is removed from the Room

- Updated the 100ms Quickstart, GetX, MobX & Riverpod based [Sample apps](https://github.com/100mslive/100ms-flutter/tree/main/sample%20apps)

Updated to Android SDK 2.5.9 & iOS SDK 0.7.1

Full Changelog: [1.3.2...1.3.3](https://github.com/100mslive/100ms-flutter/compare/1.3.2...1.3.3)

## 1.3.2 - 2023-03-09

### Fixed

- Corrected an issue with `DateTime` parsing where joining failed on iOS devices behind UTC Timezone

Updated to Android SDK 2.5.7 & iOS SDK 0.6.4

Full Changelog: [1.3.1...1.3.2](https://github.com/100mslive/100ms-flutter/compare/1.3.1...1.3.2)

## 1.3.1 - 2023-02-27

### Changed

- Performance improvements for PIP Mode on iOS
- Improved Disconnected State detection on certain Networks
- Gracefully handling of null objects

Updated to Android SDK 2.5.7 & iOS SDK 0.6.4

Full Changelog: [1.3.0...1.3.1](https://github.com/100mslive/100ms-flutter/compare/1.3.0...1.3.1)

## 1.3.0 - 2023-02-01

### Breaking

- Removed Start / Stop Capturing APIs on Local Video Tracks. Use `toggleCameraMuteState` to mute / unmute video of local peer as mentioned in Guide [here](https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/mute).

### Added

- Added support for PIP Mode on iOS

  Now on iOS devices you can show a Picture-in-Picture(PIP) window while your app is in Background. You can configure the PIP window to show the Video of currently speaking Peer, or a Screenshare happening in Room, a Remote Peer's video in 1-to-1 Video Calls, etc

  To learn more about PIP & how to implement it in your apps, refer the PIP Guide [here](https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/pip-mode#ios).

- Added `HMSPIPAndroidController` to easily configure & use PIP Mode on Android

  PIP Mode support was available on Android since version 1.0.0. With this release we have made it more easy & simple to setup PIP on Android devices. Use the new `HMSPIPAndroidController` class to configure & start playing your Live Videos when your app is in Background. Refer the PIP Guide [here](https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/pip-mode#android).

- Added Capture Snapshot API to capture a frame of the video track being rendered

  With the new `captureSnapshot()` method on `HMSVideoTrack` you can instantly capture a frame of any Video being rendered on screen. You can use this to capture moments of a Peer's Video, or a Screenshare happening in Room, etc. To learn more about how to use Capture Snapshot refer the Guide [here](https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/capture-snapshot).

### Deprecated

- Deprecated direct passing of AppGroup & PreferredExtension while building HMSSDK for iOS Screenshare. Use the new `HMSIOSScreenshareConfig` class for starting Screenshare from iOS Devices. For more details, refer the Screnshare Guide [here](https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/screen-share).

- Deprecated `switchAudio` and `switchVideo` functions to mute/unmute Audio/Video of local peer. Use `toggleMicMuteState` and `toggleCameraMuteState` functions as mentioned in the Guide [here](https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/mute).

### Fixed

- Corrected an issue where doing multiple Role Changes stopped working
- Corrected an issue where video views were getting recreated

Updated to Android SDK 2.5.7 & iOS SDK 0.6.2

Full Changelog: [1.2.0...1.3.0](https://github.com/100mslive/100ms-flutter/compare/1.2.0...1.3.0)

## 1.2.0 - 2023-01-13

### Breaking

- Made `await` while building `HMSSDK` Required

  Adding `await` to the `build()` method was optional earlier. It has been made **Required** now to eliminate edge cases where SDK initialization did not complete before invocation of `join()` method. Adding `await` ensures that an instance of HMSSDK is available before any further usages.

  ```dart
  hmsSDK = HMSSDK();

  await hmsSDK.build(); // NEW: adding await while invoking build method on HMSSDK is now Required

  hmsSDK.addUpdateListener(this);
  HMSConfig config = HMSConfig(authToken: 'eyJH5c', // client-side token generated from your token service
                          userName: 'John Appleseed');
  hmsSDK.join(config: config);
  ```

### Added

- Added support for Adaptive Bitrate (Simulcast)

  Adaptive Bitrate refers to features that enable dynamic adjustments in video quality to optimize for end-user experience under diverse network conditions.

  To learn more about how ABR works & how it enhances your app, refer the guide [here](https://www.100ms.live/docs/flutter/v2/foundation/adaptive-bitrate).

- Using HMSVideoView on Android

  HMSVideoView on Android provides a better abstraction to render live video and handles edge cases like managing Release/Init states. It has in-built support to subscribe to video of the correct resolution.

  To learn more about Rendering Video, refer the guide [here](https://www.100ms.live/docs/flutter/v2/features/render-video).

- Added Simulcast support for RTC Stats

  RTC Call Stats are updated to show Simulcast layer data if available for Local Peer's Video Track. This can be used to diagnose user experience with metrics such as Audio/Video Bitrate, Round Trip Time, Packet loss, etc.

  To learn more about using RTC Call Stats, refer the guide [here](https://www.100ms.live/docs/flutter/v2/features/call-stats).

### Changed

- Sending correct `joined_at` property on Android indicating the time when the peer joins the Room

- Logging error messages when the App Group used for starting Screenshare from iOS is incorrect

- On Android, the `onJoin` updates will now be triggered before `onPeerUpdate` when a user joins the room

Updated to Android SDK 2.5.6 & iOS SDK 0.5.5

Full Changelog: [1.1.0...1.2.0](https://github.com/100mslive/100ms-flutter/compare/1.1.0...1.2.0)

## 1.1.0 - 2022-12-17

### Added

- Added support for Bulk Role Change

  Bulk Role Change is used when you want to convert all Roles from a list of Roles, to another Role.

  For example, if peers join a room with a _Waiting_ Role and now you want to change all these peers to _Viewer_ Role then use the `changeRoleOfPeersWithRoles` API.

  ```dart
  // fetch all available Roles in the room
  List<HMSRole> roles = await hmsSDK.getRoles();

  // get the Host Role object
  HMSRole toHostRole = roles.firstWhere((element) => element.name == "host");

  // get list of Roles to be updated - in this case "Waiting" and "Guest" Roles
  roles.retainWhere((element) => ((element.name == "waiting") || (element.name == "guest")));

  // now perform Role Change of all peers in "Waiting" and "Guest" Roles to the "Host" Role
  hmsSDK.changeRoleOfPeersWithRoles(
      toRole: toHostRole,
      ofRoles: roles,
      hmsActionResultListener: hmsActionResultListener);
  ```

  For More Information, refer: https://www.100ms.live/docs/flutter/v2/features/change-role

- Added Switch Audio Output APIs on iOS

  Audio Output Routing is helpful when users want to switch output to a connected device other than the default one. This functionality is already available on Android.

  ```dart
  hmsSDK.switchAudioOutput(audioDevice: HMSAudioDevice.SPEAKER_PHONE);
  ```

  For More Information, refer: https://www.100ms.live/docs/flutter/v2/features/audio-output-routing

### Deprecated

- Deprecated `changeRole` API in favour of `changeRoleOfPeer`

  No change in functionality or method signature.

### Fixed

- Microphone not getting captured on Role Change from a non-publishing to publishing Role on iOS
- Corrected an issue where on iOS a default Audio Mixer was getting created if Track Settings was passed while building the HMSSDK instance

Updated to Native Android SDK 2.5.4 & Native iOS SDK 0.5.3

Full Changelog: [1.0.0...1.1.0](https://github.com/100mslive/100ms-flutter/compare/1.0.0...1.1.0)

## 1.0.0 - 2022-12-09

### Added

- Added support for Picture in Picture mode on Android.

  PIP Mode lets the user watch the room video in a small window pinned to a corner of the screen while navigating between apps or browsing content on the main screen.

  Example implementation for checking device support & enabling PIP mode:

  ```dart
  // to start PIP mode invoke the `enterPipMode` function, the parameters passed to it are optional
  hmsSDK.enterPipMode(aspectRatio: [16, 9], autoEnterPip: true);

  // method to check whether PIP mode is available for current device
  bool isPipAvailable = await hmsSDK.isPipAvailable();

  // method to check whether PIP mode is active currently
  bool isPipActive = await hmsSDK.isPipActive();
  ```

- Added `roomPeerCountUpdated` type in `HMSRoomUpdate`

- Added `isPlaybackAllowed` to Remote Audio & Video Tracks to check if the track is allowed to be played locally

- Added convenience APIs to Mute / Unmute Audio or Video of the entire room locally

### Fixed

- Corrected parsing of `HMSMessage` objects sent Server-side APIs
- Session Metadata can now be reset to a null value
- Importing Native Android SDK dependency from Maven Central instead of Jitpack
- HMSTrackSettings is now nullable while building the HMSSDK object
- Corrected usage of Native Util functions to fetch Audio & Video tracks
- Corrected default local audio track settings for iOS devices
- Corrected sending of peer count in `HMSRoom` instance on iOS

Updated to Native Android SDK 2.5.1 & Native iOS SDK 0.4.7

Full Changelog: [0.7.8...1.0.0](https://github.com/100mslive/100ms-flutter/compare/0.7.8...1.0.0)

## 0.7.8 - 2022-10-31

- Added support for Joining with Muted Audio & Video on iOS devices
- Added Maven Central repository to look for Android dependencies
- Added support for receiving Server-side `HMSMessage`
- Added `HMSLogSettings` to configure Native Android SDK logs
- Corrected setters for local audio/video track settings while building the `HMSSDK` object
- Updated to Native Android SDK 2.5.1 & Native iOS SDK 0.4.6

Full Changelog: [0.7.7...0.7.8](https://github.com/100mslive/100ms-flutter/compare/0.7.7...0.7.8)

## 0.7.7 - 2022-10-20

- Added ability to set & get session metadata
- Added ability to join with muted audio & video using Initial states (Muted / Unmuted) `HMSVideoTrackSettings` & `HMSAudioTrackSettings` in the builder of HMSSDK
- Added better Telemetrics for analytics
- Added option to use Software Decoder for Video rendering on Android devices
- Added action result listener to `switchCamera` function on local video track
- Fixed LetterBoxing (Black borders on top and bottom) observed when sharing the screen in landscape mode on Android
- Fixed incorrect sending of Speaker Updates when peer has left the room
- Removed unused setters for Local Audio & Video Track Settings
- Updated to Native Android SDK 2.5.0 & Native iOS SDK 0.4.5

Full Changelog: [0.7.6...0.7.7](https://github.com/100mslive/100ms-flutter/compare/0.7.6...0.7.7)

## 0.7.6 - 2022-09-23

- Added audio output change listener callback while in Preview on Android
- Added API to show Native Audio Output Picker on iOS
- Corrected an issue where audio was always coming from the Earpiece instead of Built-In Speaker on iOS
- Fixed an issue where audio gets distorted when headset is used while sharing audio playing on iOS
- Updated `HMSException` class. Added `canRetry` attribute

Full Changelog: [0.7.6...0.7.5](https://github.com/100mslive/100ms-flutter/compare/0.7.6...0.7.5)

## 0.7.5 - 2022-08-18

- Added support on iOS for sharing audio from local files on your device & from other audio playing apps
- Added ability to apply local peer track settings while initializing HMSSDK
- Added APIs to fetch local peer track settings
- Fixed an issue where exiting from Preview without joining room was not releasing camera access
- Added `destroy` API to cleanup Native HMSSDK instance correctly
- Disabled Hardware Scaler on Android to correct intermittent Video tile flickering
- Updated to Native Android SDK 2.4.8 & Native iOS SDK 0.3.3

## 0.7.4 - 2022-07-29

### Added

- Added APIs to stream device audio in different modes
- Added APIs to view and change the output speaker selected by the SDK to playout
- setAudioMode API to change the Audio out mode manually between in-call volume and media volume

### Fixed

- Calling `switchCamera` API leads to triggering of onSuccess callback twice
- onRoomUpdate with type `HMSRoomUpdate.ROOM_PEER_COUNT_UPDATED` not getting called when peer count changes in the room
- Peer not able to publish tracks when updated to WebRTC from HLS if rejoins after a reconnection in WebRTC Mode

### Changed

- `HMSHLSConfig` is now an optional parameter while calling startHLSStreaming and stopHLSStreaming
- The `meetingUrl` parameter is optional while creating the `HMSHLSMeetingURLVariant` instance for HMSHLSConfig. If nothing is provided HMS system will take the default meetingUrl for starting HLS stream
- changeRoleForce permission in HMSRole is now removed and no longer used
- recording permission in HMSRole is now broken into - `browserRecording` and `rtmpStreaming`
- streaming permission in HMSRole is now `hlsStreaming`

## 0.7.3 - 2022-06-23

- Added support for iOS Screenshare
- Added `HMSHLSRecordingConfig` to perform recording while HLS Streaming
- Updated error callback in `HMSUpdateListener` to `onHMSError`
- Updated to Native Android SDK 2.4.2 & Native iOS SDK 0.3.1

## 0.7.2 - 2022-06-02

- Segregated RTC Stats update notifications from `HMSUpdateListener` into `HMSStatsListener`
- Removed `room_peer_count_updated` from `HMSRoomUpdate` enum
- Added `sessionId` to the `HMSRoom` class
- Updated to Native Android SDK 2.3.9 & Native iOS SDK 0.3.1

## 0.7.1 - 2022-05-20

- Added RTC Stats Listener which provides info about local & remote peer's audio/video quality
- Improved video rendering performance for Android devices
- Correct RTMP Streaming & Recording configuration settings
- Added support for Server-side Subscribe Degradation
- Updated to Native Android SDK 2.3.9 & Native iOS SDK 0.2.13

## 0.7.0 - 2022-04-19

### Added

- Network Quality in preview. Network quality reports can now be requested at the preview screen. Use the returned value to determine if you should suggest people's internet is too slow to join with video etc.

- Network Quality during calls. Peer Network Quality updates are now received during the call. Use this to show how strong any peer's internet is during the call.

- Added HLS Recording to initial PeerList

- `onPeerUpdate` and `onRoomUpdate` callbacks in 'HMSPreviewListener' to get info about the room at Preview screen

- Added `startedAt` and `stoppedAt` field for Browser and SFU recording

### Fixed

- Error Analytics events not being sent

- Leave not finishing if SDK is in reconnection state. Hence all join calls after that was getting queued up if called on the same HMSSDK instance

- Improved subscribe degradation so that new add sinks are handled properly when SDK is already in degraded state

- Crash fix on starting/stopping HLS where HlsStartRecording was null

- HLS recording status wasn't always updated when stopped

- Rare crash when cameras are unavailable and it seemed to the app like none exist

- Updated to Native Android SDK 2.3.4 & Native iOS SDK 0.2.9

## 0.6.0 - 2022-01-25

### Breaking Change

- Updated Change Role APIs argument types
- Changed Messaging APIs argument types
- Updated argument types of `changeTrackState`, `changeRole`, `acceptRoleChange`, `changeTrackStateForRoles` APIs

### Added

- Added HLS Support. Now you can Start/Stop HLS Streaming from Flutter SDK
- Added support to do ScreenShare from Android device

### Changed

- Updated callbacks for Permission based action APIs

## 0.5.0 - 2022-01-15

### Breaking Change

- Renamed SDK Public interface to `HMSSDK` class
- Updated HMSConfig object which is used to join the room

### Added

- Added APIs to change remote track status
- Added APIs to start/stop Recording
- Added APIs to change metadata of local peer which can be used to implement raise hand functionality
- Added API to change name of local peer
- Added API to get current room status
- Added API to get peer audio/video status
- Added new Group & Direct Peer Messaging APIs
- Added volume setter & getter APIs on audio tracks
- Added Action Result Listeners to notify success or failure of API invocations

### Changed

- Updated `HMSException` object with `isTerminal`
- Changed `sendMessage` API to `sendBroadcastMessage` to send a message to all peers in room
- Changed `HMSMessageResultListener` to `HMSActionResultListener` in Messaging APIs
- Video Rendering flow for Android & iOS video tracks
- Preview API implementation

### Fixed

- Reconnection issues wherein even when network recovered, peer could not rejoin the room
- Cleaning up config object whenever room is joined/left

## 0.4.1

- `Added matchParent boolean on video view`

## 0.4.0

- `Updated Messaging APIs`
- `Added audio level, peer & track object in HMSSpeaker`
- `Updated track source type to string`
- `Updated sample app`

## 0.3.0

- `Corrected crash on using getLocalPeer`
- `Updated sample app`

## 0.2.0

This version of 100ms Flutter SDK comes loaded with bunch of features & improvements like -

- `Improved low network performance`
- `Added Active Speaker listener`
- `Resolved build conflicts on iOS`
- `Added APIs to Change Role of a Peer`
- `Added APIs to Mute Audio/Video of a Remote Peer`
- `Added APIs to End a Room`
- `Updated Chat Messaging APIs to enable Broadcast, Group & Personal`
- `Improved Reconnection after network switch/loss`
- `Improved Interruption Handling when a Meeting is ongoing`

## 0.1.0

The first version of 100ms Flutter SDK comes power-packed with support for multiple features like -

- `Join/Leave Rooms`
- `Mute / Unmute Audio / Video`
- `Switch Camera`
- `Chat`
- `Preview Screen`
- `Network Switch Support`
- `Subscribe Degradation in bad network scenarios`
- `Error Handling and much more.`

Take it for a spin! 🥳
