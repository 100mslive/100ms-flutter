---
title: Remove Peer
nav: 11
---

Someone's overstayed their welcome and now you need to remove a peer from the video call room. Just call `meeting.removePeer`.

### Permissions

Can't let just anyone remove others from the video call room. First you need to create a [role](../foundation/templates-and-roles) with the permissions to remove others.

In the SDK, the permission to remove others from the room is within `PermissionsParams` `removeOthers` and you should check for that within the `HMSRole` of the peer to see if they have it.

Here's how to check whether the local peer has the permission to end the room:


```dart
  bool isAllowedToRemovePeer() async{
    return (await meeting.getLocalPeer()).role.permission!.removeOthers;
  }
```




`meeting.getLocalPeer()` will not return null as long as you're in a preview or in a meeting. Since you likely won't need to check for permissions if you're not in one it would be ok.

### Removing a peer

Once the permissions are checked to ensure the caller has the permission to remove a peer, remove them by calling `meeting.removePeer`.

The parameters are:

peerId: is the `HMSRemotePeer` id that you'd like to be removed from the video call room.


```dart
    meeting.removePeer(peerId);
```

### Handling the remove peer callback

The target of the `removePeerRequest` will receive a call in `HMSUpdateListener` of `onRemovedFromRoom(notification : HMSRemovedFromRoom)`.

The `HMSRemovedFromRoom` object which is passed into the callback has the structure:

```dart
    class HMSRemovedFromRoom {
      final HMSPeer peerWhoRemoved;
      final String reason;
      final bool roomWasEnded;
    }
```

reason: Is the string that the caller of `removePeerRequest` sent as the reason they were being removed from the room.

peerWhoRemoved: Is an `HMSRemotePeer` instance containing the details of the person who called `removePeerRequest`. This can be used to show the name of the person who removed them.

roomWasEnded: This will be false if the peer was removed. If true, it indicates that the peer was not removed, but the entire room was ended. See [End Room](End-Room) for details.

When this callback is received, the UI should be cleaned up from the client side. The video call room would be ended from the SDK once this callback is sent.