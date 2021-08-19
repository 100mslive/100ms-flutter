


# invokeMethod method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html) invokeMethod
([PlatformMethod](../../common_platform_methods/PlatformMethod-class.md) method, {[Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)? arguments})





<p>used to invoke different methods at platform side and returns something but not neccessarily</p>



## Implementation

```dart
static Future<dynamic> invokeMethod(PlatformMethod method,
    {Map? arguments}) async {
  if (!isStartedListening) {
    isStartedListening = true;
    updatesFromPlatform();
  }
  var result = await _channel.invokeMethod(
      PlatformMethodValues.getName(method), arguments);
  print(result);
  return result;
}
```







