


# leaveMeeting method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void> leaveMeeting
()





<p>just call this method to leave meeting.</p>



## Implementation

```dart
Future<void> leaveMeeting() async {
  return await PlatformService.invokeMethod(PlatformMethod.leaveMeeting);
}
```







