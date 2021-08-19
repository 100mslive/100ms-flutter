


# isMute method




    *[<Null safety>](https://dart.dev/null-safety)*



- @[override](https://api.flutter.dev/flutter/dart-core/override-constant.html)

[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)> isMute
()

_override_






## Implementation

```dart
@override
Future<bool> isMute() async {
  //TODO:: make platform call
  return await PlatformService.invokeMethod(PlatformMethod.isVideoMute,arguments: {"peer_id":peer!.peerId,"is_local":peer!.isLocal});

}
```







