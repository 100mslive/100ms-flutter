---
title: Change Track State
nav: 3.92
---

Changing track state is a concept that allows users to mute other peers's audio / video and request unmute other peer's audio / video if they have required permissions or not according to their role.

## Check if user has permissions

```dart
val mute= peer.role.permissions.mute;
val unmute= peer.role.permissions.unmute;
```

## Example

Imagine a room with 10 people having 3 speakers and they have to speak one by one. The first speaker can mute other 2 speakers and start. After some point when the first speaker is finished they can mute himself and request other speakers to unmute.

## Mute other tracks

If you have the required permissions you can mute remote tracks audio / video. The track of the remote peer would be muted without any requests.

```dart
val mute= true;

// instance acquired from build() method
meeting.changeTrackRequest(peerid, mute:true,isVideoTrack:true);
meeting.changeTrackRequest(peerid, mute:true,isVideoTrack:false);
```

## Unmute other tracks

If you have the required permissions you can request to unmute remote tracks audio / video. If the request is accepted by the remote peer ON_TRACK_UPDATE listener will get triggered.

```dart
val unmute= false;

// instance acquired from build() method
meeting.changeTrackRequest(peerId:"", mute:false,isVideoTrack:true);
meeting.changeTrackRequest(peerId, mute:false,isVideoTrack:false);
```

## Accept Track change request

Once the peer with adequate permissions calls change track state or unmute, you can either accept or reject the request.
You will get onSuccess callback in hmsActionResultListener
and if any failures occur wou will get in onError update.

```dart
    ///You will get update that someone has requested to change your track only if your audio or video is off.
    @override
    void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    
  }


    ///You can change remote peer Track both audio and video 
    meeting.changeTrackRequest(peerId,mute,isVideoTrack,hmsActionResultListener);
```
