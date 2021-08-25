


# startCapturing method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void> startCapturing
()








## Implementation

```dart
Future<void> startCapturing() async{
  await PlatformService.invokeMethod(PlatformMethod.startCapturing);
}
```







