


# HMSTrack.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSTrack.fromMap({required [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map, [HMSPeer](../../model_hms_peer/HMSPeer-class.md)? peer})





## Implementation

```dart
factory HMSTrack.fromMap({required Map map, HMSPeer? peer}) {
  return HMSTrack(
      trackId: map['track_id'],
      trackDescription: map['track_description'],
      source:
          HMSTrackSourceValue.getHMSTrackSourceFromName(map['track_source']),
      kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
      peer: peer);
}
```







