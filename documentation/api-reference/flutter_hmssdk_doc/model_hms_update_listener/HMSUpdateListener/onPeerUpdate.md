


# onPeerUpdate method




    *[<Null safety>](https://dart.dev/null-safety)*




void onPeerUpdate
({required [HMSPeer](../../model_hms_peer/HMSPeer-class.md) peer, required [HMSPeerUpdate](../../enum_hms_peer_update/HMSPeerUpdate-class.md) update})





<p>This will be called whenever there is an update on an existing peer
or a new peer got added/existing peer is removed.</p>
<p>This callback can be used to keep a track of all the peers in the room</p>
<ul>
<li>Parameters:
<ul>
<li>peer: the peer who joined/left or was updated</li>
<li>update: the triggered update type. Should be used to perform different UI Actions</li>
</ul>
</li>
</ul>



## Implementation

```dart
void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update});
```







