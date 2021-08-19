


# switchVideo method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void> switchVideo
({[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) isOn = false})





<p>switch local video on/off.
///just pass false or true to switchVideo</p>



## Implementation

```dart
Future<void> switchVideo({bool isOn = false}) async {
  return await PlatformService.invokeMethod(PlatformMethod.switchVideo,
      arguments: {'is_on': isOn});
}
```







