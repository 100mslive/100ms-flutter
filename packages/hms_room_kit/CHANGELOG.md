# Latest Versions

| Package        | Version                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------ |
| hms_room_kit   | [![Pub Version](https://img.shields.io/pub/v/hms_room_kit)](https://pub.dev/packages/hms_room_kit)     |
| hmssdk_flutter | [![Pub Version](https://img.shields.io/pub/v/hmssdk_flutter)](https://pub.dev/packages/hmssdk_flutter) |

## 1.0.13 - 2024-02-16

| Package        | Version                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------ |
| hms_room_kit   | 1.0.13    |
| hmssdk_flutter | 1.9.10     |

### 🚀 Added

- Introducing quizzes on prebuilt

  Users can now create, manage, and stop quizzes directly from the prebuilt interface.

Updated `hmssdk_flutter` package version to 1.9.10

## 1.0.12 - 2024-02-12

| Package        | Version                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------ |
| hms_room_kit   | 1.0.12    |
| hmssdk_flutter | 1.9.9     |

### 🚀 Added

- Introducing polls on prebuilt

  Users can now create, manage, and stop polls directly from the prebuilt interface.

Updated `hmssdk_flutter` package version to 1.9.9

## 1.0.11 - 2024-02-01

| Package        | Version                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------ |
| hms_room_kit   | 1.0.11    |
| hmssdk_flutter | 1.9.8     |

Updated `hmssdk_flutter` package version to 1.9.8

## 1.0.10 - 2024-01-18

| Package        | Version                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------ |
| hms_room_kit   | 1.0.10     |
| hmssdk_flutter | 1.9.7     |

### 🚀 Added

- Auto-Hide Top & Bottom Bars after 5 seconds

  Top & Bottom Bars will be hidden after 5 seconds of inactivity.

## 1.0.9 - 2024-01-15

| Package        | Version                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------ |
| hms_room_kit   | 1.0.9     |
| hmssdk_flutter | 1.9.6     |

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

| Package        | Version                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------ |
| hms_room_kit   | 1.0.8     |
| hmssdk_flutter | 1.9.5     |

### 🔄 Changed

- Updated Streaming and Recording UI

## 1.0.7 - 2023-12-08

| Package        | Version                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------ |
| hms_room_kit   | 1.0.7     |
| hmssdk_flutter | 1.9.4     |

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
