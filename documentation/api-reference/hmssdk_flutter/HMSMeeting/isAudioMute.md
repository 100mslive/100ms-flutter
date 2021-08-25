


# isAudioMute method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)> isAudioMute
([HMSPeer](../../hmssdk_flutter/HMSPeer-class.md)? peer)





<p>checks the audio is mute or unmute just pass <code>peer</code></p>



## Implementation

```dart
Future<bool> isAudioMute(HMSPeer? peer) async {
  bool isMute = await PlatformService.invokeMethod(PlatformMethod.isAudioMute,
      arguments: {"peer_id": peer?.peerId ?? ""});
  return isMute;
}
```







