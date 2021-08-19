


# sendMessage method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void> sendMessage
([String](https://api.flutter.dev/flutter/dart-core/String-class.html) message)





<p>send message to the room and the pass the <code>message</code>.</p>



## Implementation

```dart
Future<void> sendMessage(String message) async {
  return await PlatformService.invokeMethod(PlatformMethod.sendMessage,
      arguments: {"message": message});
}
```







