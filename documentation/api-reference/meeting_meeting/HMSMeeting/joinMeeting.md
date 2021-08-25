


# joinMeeting method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void> joinMeeting
({required [HMSConfig](../../model_hms_config/HMSConfig-class.md) config})





<p>join meeting by passing HMSConfig instance to it.</p>



## Implementation

```dart
Future<void> joinMeeting({required HMSConfig config}) async {
  return await PlatformService.invokeMethod(PlatformMethod.joinMeeting,
      arguments: config.getJson());
}
```







