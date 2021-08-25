


# HMSLocalPeer constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSLocalPeer({required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) peerId, required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) name, required [bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) isLocal, [HMSRole](../../model_hms_role/HMSRole-class.md)? role, [String](https://api.flutter.dev/flutter/dart-core/String-class.html)? customerUserId, [String](https://api.flutter.dev/flutter/dart-core/String-class.html)? customerDescription, [HMSAudioTrack](../../model_hms_audio_track/HMSAudioTrack-class.md)? audioTrack, [HMSVideoTrack](../../model_hms_video_track/HMSVideoTrack-class.md)? videoTrack, [List](https://api.flutter.dev/flutter/dart-core/List-class.html)&lt;[HMSTrack](../../model_hms_track/HMSTrack-class.md)>? auxiliaryTracks})





## Implementation

```dart
HMSLocalPeer({
  required String peerId,
  required String name,
  required bool isLocal,
  HMSRole? role,
  String? customerUserId,
  String? customerDescription,
  HMSAudioTrack? audioTrack,
  HMSVideoTrack? videoTrack,
  List<HMSTrack>? auxiliaryTracks,
}) : super(
          isLocal: isLocal,
          name: name,
          peerId: peerId,
          customerUserId: customerUserId,
          customerDescription: customerDescription,
          role: role,
          audioTrack: audioTrack,
          videoTrack: videoTrack,
          auxiliaryTracks: auxiliaryTracks);
```







