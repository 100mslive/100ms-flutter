---
title: Remote Mute
nav: 11
---

You're running a video call room and decide that someone who's currently talking shouldn't be talking.

You'd prefer they'd stay mute. Or perhaps you want their video turned off as well as their audio. You're looking for a remote mute.

Muting can apply to both audio and video.

##### Unmuting

You may also decide that you want to let someone else speak who was currently muted. Or may want to ask someone to turn on their video.

You can request people to unmute themselves as well.

### Permissions

Can't let just anyone mute others. First you need to create a [role](../foundation/templates-and-roles) with the permissions to mute others and also to ask them to unmute.

The permission to mute others is within  `PermissionsParams` `mute` and you should check for that within the `HMSRole` of the peer to see if they have it.

Similarly the permission to unmute other peers is within `PermissionsParams` `unmute`.

Here's how to check whether the local peer has the permission to mute or unmute others. You can do it like this:



```dart

HMSMeeting meeting = new Meeting();
Future<bool> isAllowedToMuteOthers() async{
    return (await meeting.getLocalPeer()).role.permission!.mute;
}

Future<bool> isAllowedToUnMuteOthers(){
    return (await meeting.getLocalPeer()).role.permission!.unMute;
}

```






`meeting.getLocalPeer()` will not return null as long as you're in a preview or in a meeting. Since you likely won't need to check for permissions if you're not in one it would be ok.



### Handling a mute callback

Mute callbacks are automatically applied to the receiver. No action is required.

### Handling an unmute callback
Unmute callbacks are received in the target peer's `HMSUpdateListener.onChangeTrackStateRequest`.

The target peer will receive an object of `HMSChangeTrackStateRequest`.

Here's its structure.

```dart
class HMSChangeTrackStateRequest{
    bool mute;
    HMSPeer requestBy;
    HMSTrack track;

    HMSTrackChangeRequest({required this.mute,required this.requestBy,  required this.track});
  }
```

This contains information on which track is requested for unmuting. Check the track type and inform the user as appropriate.


```dart
public void checkTrack(HMSTrackKind track) {
    if( track.getType() == HMSTrackType.kHMSTrackKindAudio) {

    } else if (track.getType() == HMSTrackType.kHMSTrackKindVideo) {
        
    }
}
```



Hold onto the information here, show a dialog to the user to ask if they want to accept the change and then apply the settings locally. The same as in a regular user [Mute/Unmute](Mute).