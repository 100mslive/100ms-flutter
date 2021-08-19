


# platformVersion property




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html)?> platformVersion
  







## Implementation

```dart
static Future<String?> get platformVersion async {
  final String? version = await _channel.invokeMethod('getPlatformVersion');
  return version;
}
```








