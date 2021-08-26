# Change Role
<img src="https://docs.100ms.live/guides/role-change.png">

Role is a powerful concept that takes a lot of complexity away in handling permissions and supporting features like breakout rooms. <a href="https://docs.100ms.live/flutter/v2/foundation/templates-and-roles">Learn more about roles here</a>.

Every peer is associated with a role. The HMSRole object can be used to know the following:

1. Check what this role is allowed to publish. i.e can it send video (and at what resolution)? can it send audio? can it share screen? This can be discovered by using <span style="color:blue">`selectIsAllowedToPublish`</span> to display the UI appropriately.

2. Check which other roles can this role subscribe to. This is internally taken care of by the 100ms infra and sdk, and your UI will only get tracks as per allowed subscriptions. <span style="color:blue">`role.subscribeParams`</span> can be used to get details.

3. Check what actions this role can perform. i.e can it change someone else's current role, end meeting, remove someone from the room. This can be discovered by using the <span style="color:blue">`selectPermissions`</span>.

In certain scenarios you may want to change someone's role. Imagine an audio room with 2 roles "speaker" and "listener". Only someone with a "speaker" role can publish audio to the room while "listener" can only subscribe. Now at some point "speaker" may decide to nominate some "listener" to become a "speaker". This is where the `changeRole` API comes in.

To invoke the api you will need 3 things.

* `peerId`: The remote peer ID whose role you want to change.

* `roleName`: The target role name.

* `forceChange` : Whether you want to change their role without asking them or give them a chance to accept/reject.

All the peers that are in the current room are accessible via `HMSTrack` objects received from `HMSUpdateListener.onTrackUpdate`.

A list of all available role names in the current room can be accessed via the `getRoles`function of `HMSMeeting`. (`Upcoming` : `selectRoleByRoleName` function will help you get the full role object for a role name which will have the role's permissions and what they're allowed to do.)

Once you have all you can invoke:

```dart:
  void changeRole(
      String peerId,
      String roleName,
      bool forceChange = false) {

    meeting.changeRole(
        peerId: peerId, roleName: roleName, forceChange: forceChange);

  }

```

The force parameter in changeRole, when false, is a polite request: "Would you like to change your role from listener to speaker?" which can be ignored by the other party. The way it works is the other party will first receive a request which they can accept or reject.

You will get role change requests in `HMSUpdateListener.onRoleChangeRequest`.

```dart:
/// You get onRoleChangeRequest function in the class which implemented the HMSUpdateListener.
  
   @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // Show dialog/ui to user to accept or reject the role change request
  }
```

If the request is accepted, the `peer.roleName` field in the store will update for all peers which should update their UI as well.

Imagine that the newly nominated speaker is not behaving nicely and we want to move him back to listener without a prompt. This is where the `force` parameter comes in. When it is set to `true` the other party will not receive a confirmation `roleChangeRequest` but instead will straight away receive a new set of updated permissions and stop publishing.

<img src="https://docs.100ms.live/guides/role-listener.png">