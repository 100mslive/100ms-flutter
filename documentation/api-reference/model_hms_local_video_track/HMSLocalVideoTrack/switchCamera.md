


# switchCamera method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void> switchCamera
()








## Implementation

```dart
Future<void> switchCamera() async{
  await PlatformService.invokeMethod(PlatformMethod.switchCamera);
}
```







