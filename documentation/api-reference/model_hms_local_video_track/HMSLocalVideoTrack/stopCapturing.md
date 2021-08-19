


# stopCapturing method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void> stopCapturing
()








## Implementation

```dart
Future<void> stopCapturing() async{
  await PlatformService.invokeMethod(PlatformMethod.stopCapturing);
}
```







