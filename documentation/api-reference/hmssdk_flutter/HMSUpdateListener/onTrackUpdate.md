


# onTrackUpdate method




    *[<Null safety>](https://dart.dev/null-safety)*




void onTrackUpdate
({required [HMSTrack](../../hmssdk_flutter/HMSTrack-class.md) track, required [HMSTrackUpdate](../../hmssdk_flutter/HMSTrackUpdate-class.md) trackUpdate, required [HMSPeer](../../hmssdk_flutter/HMSPeer-class.md) peer})





<p>This is called when there are updates on an existing track
or a new track got added/existing track is removed</p>
<p>This callback can be used to render the video on screen whenever a track gets added</p>
<ul>
<li>Parameters:
<ul>
<li>track: the track which was added, removed or updated</li>
<li>trackUpdate: the triggered update type</li>
<li>peer: the peer for which track was added, removed or updated</li>
</ul>
</li>
</ul>



## Implementation

```dart
void onTrackUpdate(
    {required HMSTrack track,
    required HMSTrackUpdate trackUpdate,
    required HMSPeer peer});
```







