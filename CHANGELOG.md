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
