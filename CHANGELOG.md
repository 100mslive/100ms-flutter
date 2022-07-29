## 0.7.4 - 2022-07-29

### Added

- Added APIs to stream device audio in different modes
- Added  APIs to view and change the output speaker selected by the SDK to playout
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
