


# isVideoMute method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)> isVideoMute
([HMSPeer](../../model_hms_peer/HMSPeer-class.md)? peer)





<p>checks the video is mute or unmute just pass <code>peer</code></p>



## Implementation

```dart
Future<bool> isVideoMute(HMSPeer? peer) async{
  bool isMute=await PlatformService.invokeMethod(PlatformMethod.isVideoMute,arguments: {"peer_id":peer?.peerId??""});
  return isMute;
}
```







