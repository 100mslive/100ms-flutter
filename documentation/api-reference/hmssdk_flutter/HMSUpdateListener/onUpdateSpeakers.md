


# onUpdateSpeakers method




    *[<Null safety>](https://dart.dev/null-safety)*




void onUpdateSpeakers
({required [List](https://api.flutter.dev/flutter/dart-core/List-class.html)&lt;[HMSSpeaker](../../hmssdk_flutter/HMSSpeaker-class.md)> updateSpeakers})





<p>This is called every 1 second with list of active speakers</p>
<h2 id="a-hmsspeaker-object-contains--">A HMSSpeaker object contains -</h2>
<ul>
<li>peerId: the peer identifier of HMSPeer who is speaking</li>
<li>trackId: the track identifier of HMSTrack which is emitting audio</li>
<li>audioLevel: a number within range 1-100 indicating the audio volume</li>
</ul>
<p>A peer who is not present in the list indicates that the peer is not speaking</p>
<p>This can be used to highlight currently speaking peers in the room</p>
<ul>
<li>Parameter speakers: the list of speakers</li>
</ul>



## Implementation

```dart
void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers});
```







