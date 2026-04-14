# Latest Versions

| Package          | Version                                                                                                    |
| ---------------- | ---------------------------------------------------------------------------------------------------------- |
| hms_room_kit     | [![Pub Version](https://img.shields.io/pub/v/hms_room_kit)](https://pub.dev/packages/hms_room_kit)         |
| hmssdk_flutter   | [![Pub Version](https://img.shields.io/pub/v/hmssdk_flutter)](https://pub.dev/packages/hmssdk_flutter)     |
| hms_video_plugin | [![Pub Version](https://img.shields.io/pub/v/hms_video_plugin)](https://pub.dev/packages/hms_video_plugin) |

# 1.2.1 - 2026-04-10

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.2.1   |
| hmssdk_flutter | 1.11.1  |

### Added

- Request `BLUETOOTH_CONNECT` runtime permission on Android 12+ alongside camera and microphone for Bluetooth audio device support.

### Changed

- Updated `hmssdk_flutter` dependency to 1.11.1.

# 1.2.0 - 2025-10-29

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.2.0   |
| hmssdk_flutter | 1.11.0  |

### Breaking Changes

- **Minimum Flutter version updated to 3.24.0** (previously 3.10.0)
- **Android minimum SDK increased to API 24** (previously 21)
- **iOS deployment target updated to 16.0** (previously 13.0)
- **Android now supports 64-bit architectures only** (arm64-v8a, x86_64) for 16KB page size compliance

### Platform Updates

#### Android

- Updated Android Gradle Plugin to 8.9.0 (from 7.x)
- Updated compile SDK to API 36 (from API 34)
- Updated target SDK to API 36 (from API 34)
- Updated Gradle to 8.10+ (from 7.x)
- Updated Kotlin to 2.1.10
- Updated NDK to r28 (27.2.12479018)
- Added 64-bit architecture requirement for Google Play 16KB page size support
- Removed support for 32-bit architectures (armeabi-v7a, x86)

#### iOS

- Updated iOS deployment target to 16.0 (from 13.0)
- Updated 100ms iOS SDK to 1.17.0 (from 1.16.1)
- Updated iOS Broadcast Extension to 1.0.1 (from 0.0.9)

### Dependencies

- Updated `lints` to ^6.0.0 (from ^3.0.0)
- Updated various UI dependencies to latest stable versions:
  - `intl`: ^0.20.2
  - `permission_handler`: ^12.0.1
  - `provider`: ^6.1.5+1
  - `google_fonts`: ^6.3.2
  - `shared_preferences`: ^2.5.3
  - `lottie`: ^3.3.2
  - `flutter_svg`: ^2.2.1
  - `url_launcher`: ^6.3.2
  - `share_plus`: ^12.0.1
  - `webview_flutter`: ^4.13.0
  - `image_picker`: ^1.2.0

### Native SDK Versions

- **Android SDK**: 2.9.78 (from 2.9.67)
- **iOS SDK**: 1.17.0 (from 1.16.1)
- **iOS Broadcast Extension**: 1.0.1 (from 0.0.9)

### Additional Information

- **Improved Performance**: Enhanced video rendering and overall app performance
- **Google Play Compliance**: Full support for Android 16KB page size requirement
- **Updated Build Tools**: Latest stable versions of all build tools and dependencies

**Note:** These changes ensure compatibility with the latest platform requirements and improve overall stability and performance. Apps must be updated to maintain Google Play Store compliance.

Uses Android SDK 2.9.78 & iOS SDK 1.17.0

**Full Changelog**: [1.1.6...1.2.0](https://github.com/100mslive/100ms-flutter/compare/1.1.6...1.2.0)

# 1.1.6 - 2024-09-17

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.1.6   |
| hmssdk_flutter | 1.10.6  |

### Breaking Changes in hms_room_kit

- Removed Noise Cancellation dependency from Prebuilt on Android

  Noise Cancellation dependency is removed from Prebuilt on Android.
  Users will have to add the dependency manually in their Android project to use Noise Cancellation.
  This change is made to reduce the size of the Prebuilt package.
  Refer to the [Noise Cancellation](https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/noise-cancellation) documentation for more details.

### hmssdk_flutter

- Added Camera Zoom Controls in `HMSCameraControls`

  Users can now control the camera zoom using the `HMSCameraControls` class. The `setZoom` method can be used to set the zoom level of the camera.

  Learn more about Camera Zoom Controls [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/configure-your-device/camera/camera-controls).

### hms_room_kit

- Added support to control Automatic Gain Control and Noise Suppresion in Prebuilt

  Prebuilt now supports toggling Automatic Gain Control (AGC) and Noise Suppresion for better audio quality. Users can enable or disable AGC and Noise Suppresion from the prebuilt interface.

- Resolved an issue where the Prebuilt UI was not updating on performing End Session

- Hand Raise sorting based on Time

  Hand Raise list is now sorted based on the time of raising the hand. Refer to the [Hand Raise](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/peer/large-room) documentation for more details.

- Added support to perform Switch Role of any user on Prebuilt

  Users can now switch the role of any user, if they have necessary permissions, from the Prebuilt interface. Refer to the [Change Role](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/peer/change-role) documentation for more details.

Uses `hmssdk_flutter` package version 1.11.0

## 1.1.5 - 2024-07-25

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.1.5   |
| hmssdk_flutter | 1.10.5  |

### 🚀 Added

- Noise Cancellation initial state customisation

  Noise cancellation initial state can now be customised from the prebuilt customiser.

Uses `hmssdk_flutter` package version 1.10.5

## 1.1.4 - 2024-07-01

| Package          | Version |
| ---------------- | ------- |
| hms_room_kit     | 1.1.4   |
| hmssdk_flutter   | 1.10.4  |
| hms_video_plugin | 0.0.2   |

### 🚀 Added

- Introducing live transcription options in prebuilt

  Prebuilt now supports live transcription for better accessibility. Users can enable or disable live transcription from the prebuilt interface.

Uses `hmssdk_flutter` package version 1.10.4

## 1.1.3 - 2024-06-12

| Package          | Version |
| ---------------- | ------- |
| hms_room_kit     | 1.1.3   |
| hmssdk_flutter   | 1.10.3  |
| hms_video_plugin | 0.0.1   |

### 🚀 Added

- Hand Raise can now be controlled from dashboard

  Hand Raise feature can now be enabled or disabled from the dashboard prebuilt customiser.

Uses `hmssdk_flutter` package version 1.10.3

## 1.1.2 - 2024-05-15

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.1.2   |
| hmssdk_flutter | 1.10.2  |

### 🚀 Added

- Whiteboard support in Prebuilt

  Prebuilt now supports whiteboard for better collaboration. Users can create, manage, and stop whiteboards directly from the prebuilt interface.

- Introducing option to select layers in HLS Player

  HLS Player now supports layer selection from HLS Player Settings.

Uses `hmssdk_flutter` package version 1.10.2

## 1.1.1 - 2024-04-26

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.1.1   |
| hmssdk_flutter | 1.10.1  |

### 🚀 Added

- Support for captions in HLS Player

  HLS Player now supports captions for better accessibility. This can be enabled or disabled from the player settings.

- Introducing Landscape Mode for HLS Player

  HLS Player now supports landscape mode for better viewing experience.

Uses `hmssdk_flutter` package version 1.10.1

## 1.1.0 - 2024-04-22

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.1.0   |
| hmssdk_flutter | 1.10.0  |

### 🚀 Added

- Newly designed UI for SIP Peers

  SIP peers will now have a newly designed UI to match the overall theme of the application.

- Enhanced Prebuilt with Noise Cancellation

  Prebuilt supports noise cancellation out of the box. Users can enable or disable noise cancellation from the prebuilt interface.

- All-New HLS Player Interface

  HLS Player now has a new look and feel to enhance the overall user experience.

### 🔄 Changed

- Removed `flutter_foreground_task` dependency from prebuilt

  Prebuilt no longer uses `flutter_foreground_task` package. For apps that require foreground service, the package can be added on the application level.

Uses `hmssdk_flutter` package version 1.10.0

## 1.0.17 - 2024-04-01

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.0.17  |
| hmssdk_flutter | 1.9.14  |

Uses `hmssdk_flutter` package version 1.9.14

## 1.0.16 - 2024-03-15

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.0.16  |
| hmssdk_flutter | 1.9.13  |

### 🚀 Added

- Ability to join rooms directly without preview

  Prebuilt now allows direct room joining without preview, customizable via the dashboard's "customize prebuilt" section.

Updated `hmssdk_flutter` package version to 1.9.13

## 1.0.15 - 2024-03-04

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.0.15  |
| hmssdk_flutter | 1.9.12  |

### 🚀 Added

- Ability to fetch concluded and draft polls

  Prebuilt now fetches all the polls happened during the session. Additionally, users can now retrieve draft polls from other platforms and launch them.

Updated `hmssdk_flutter` package version to 1.9.12

## 1.0.14 - 2024-02-26

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.0.14  |
| hmssdk_flutter | 1.9.11  |

### 🚀 Added

- Introducing leaderboards to our quiz experience

  Adding leaderboard to our quizzes with leaderboard summary and rankings.

Updated `hmssdk_flutter` package version to 1.9.11

## 1.0.13 - 2024-02-16

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.0.13  |
| hmssdk_flutter | 1.9.10  |

### 🚀 Added

- Introducing quizzes on prebuilt

  Users can now create, manage, and stop quizzes directly from the prebuilt interface.

Updated `hmssdk_flutter` package version to 1.9.10

## 1.0.12 - 2024-02-12

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.0.12  |
| hmssdk_flutter | 1.9.9   |

### 🚀 Added

- Introducing polls on prebuilt

  Users can now create, manage, and stop polls directly from the prebuilt interface.

Updated `hmssdk_flutter` package version to 1.9.9

## 1.0.11 - 2024-02-01

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.0.11  |
| hmssdk_flutter | 1.9.8   |

Updated `hmssdk_flutter` package version to 1.9.8

## 1.0.10 - 2024-01-18

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.0.10  |
| hmssdk_flutter | 1.9.7   |

### 🚀 Added

- Auto-Hide Top & Bottom Bars after 5 seconds

  Top & Bottom Bars will be hidden after 5 seconds of inactivity.

## 1.0.9 - 2024-01-15

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.0.9   |
| hmssdk_flutter | 1.9.6   |

### 🚀 Added

- Enhanced Chat Controls
  - 📌 Pin and Hide Messages

    Elevate your chat experience with our new room kit feature. Effortlessly pin messages to keep them visible at the top of your chat, or hide messages to remove them from view.

  - 🔒 Chat Moderation

    Gain more control over your chat environment. You can now temporarily block peers within a session, preventing them from sending messages.

  - 👥 Recipient Selector

    Communication tailored to your needs. Send broadcast messages, reach specific groups or roles, and initiate direct messages (DMs) to particular peers with ease.

  - 📋 Copy Messages

    Simplify your interactions. Copy any message quickly with just a single tap, enhancing your chat efficiency.

- Added Skip Preview for Role Change functionality

  100ms Prebuilt now supports skipping preview screen, while changing roles. This can be configured from 100ms dashboard.
  If preview screen is skipped, then mic and camera will be muted by default.

## 1.0.8 - 2023-12-15

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.0.8   |
| hmssdk_flutter | 1.9.5   |

### 🔄 Changed

- Updated Streaming and Recording UI

## 1.0.7 - 2023-12-08

| Package        | Version |
| -------------- | ------- |
| hms_room_kit   | 1.0.7   |
| hmssdk_flutter | 1.9.4   |

### 🚀 Added

- If `userName` is specified in `HMSPrebuiltOptions`, username editing on the preview screen will be disabled.

### 🛠️ Fixed

- Active speaker not updating on first page with active screenshare.

- Improved overall performance of the application.

### 🔄 Changed

- `hms_room_kit` now uses `HMSTextureView` instead of `HMSVideoView` for rendering video.

## 1.0.6 - 2023-11-17

### 🚀 Added

- Added options to Mute Session or Change Audio Output

## 1.0.5 - 2023-11-09

### 🚀 Fixed

- To handle error in case the logo url returns error

## 1.0.4 - 2023-11-03

### 🚀 Added

- Added capabilities to show/hide controls onTap in conferencing UI
- Updated error message description for error toasts.

## 1.0.3 - 2023-10-16

### 🚀 Added

- Large Room Support
  - Enhanced Participants list to accommodate up to 20,000 peers in a room.

- Added recording state indicator: showcasing "initializing" and "running" states.
- Added `Lower Hand` Capability in Participant list

### Fixed

- Fixed `userid` bug, where `userid` was not getting passed to SDK
- Fixed UI bugs

## 1.0.2 - 2023-09-22

### 🚀 Added

- Added `onLeave` callback parameter in `HMSPrebuilt`

### Changed

- Bump minimum Flutter version to 3.10.0

- Bug fixes and performance improvements

## 1.0.1 - 2023-09-15

### 🚀 Added

- Added capability to pass your own init and token endPoints

## 1.0.0 - 2023-09-15

### 🚀 Added

- Equal Prominence Layout
- Active Speaker Sorting
- Newly Designed Header and Footer
- Inset Tile for Local Peer
- Preview For Role
- Edge To Edge HLS Player
- Updated Bottom Sheets
  And much more. Take it for a spin!

## 0.1.0 - 2023-08-18

### 🚀 Added

- Equal Prominence Layout
- Active Speaker Sorting
- Newly Designed Header and Footer
- Inset Tile for Local Peer
  And much more. Take it for a spin!

## 0.0.4 - 2023-08-01

- Fixed theming issues
- Fixed issues for flutter versions below 3.10.x
- Updated preview flow

## 0.0.3 - 2023-07-20

- Updated asset path in prebuilt UI

## 0.0.2 - 2023-07-19

- Updated Package's public headers

## 0.0.1 - 2023-07-19

- Presenting 100ms Room Kit which provides simple & easy to use widgets to create immersive Live Streaming & Video Conferencing experiences in your apps. Take it for a spin!
