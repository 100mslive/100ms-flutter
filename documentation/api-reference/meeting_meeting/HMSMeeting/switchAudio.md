


# switchAudio method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void> switchAudio
({[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) isOn = false})





<p>switch local audio on/off.
just pass false or true to switchAudio</p>



## Implementation

```dart
Future<void> switchAudio({bool isOn = false}) async {
  return await PlatformService.invokeMethod(PlatformMethod.switchAudio,
      arguments: {'is_on': isOn});
}
```







