---
title: Show Audio Levels
nav: 3.99
---

### Getting Audio Levels for all speaking peers

```dart
@override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
  }
```


Here are the properties on the HMSSpeaker class:

1. audiolevel : Number -> The level of the audio. It may vary from 0-100. A higher value indicates a higher speaking volume.
2. track : HMSTrack -> The audio track corresponding to this speaker. It may be null when the speaker who was speaking loudly, leaves.
3. peer : HMSPeer -> The peer who was speaking. This may be null if the peer has left before the update information has reached the other person.



### Active Speaker Views
To maintain an active speaker view, such as the default view in the open source advanced sample app, you need to keep track of who the active
speakers are over time. We'll be using the input from `onUpdateSpeaker` listener update as mentioned above and then building something that attempts to show all
the active speakers while minimizing re-ordering the list.



### Dominant Speaker - the loudest speaker.
The dominant speaker is the speaker who's the loudest at any given moment. There's a callback for this in the onPeerUpdate callback for HMSUpdateListener.

In onUpdateSpeaker the list updateSpeakers contains the dominant speaker at first index.



