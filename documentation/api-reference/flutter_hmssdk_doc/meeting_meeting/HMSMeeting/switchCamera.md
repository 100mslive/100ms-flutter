


# switchCamera method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void> switchCamera
()





<p>switch camera to front or rear.</p>



## Implementation

```dart
Future<void> switchCamera() async {
  return await PlatformService.invokeMethod(
    PlatformMethod.switchCamera,
  );
}
```







