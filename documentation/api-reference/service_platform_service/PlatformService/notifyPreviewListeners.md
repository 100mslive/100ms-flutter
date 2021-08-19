


# notifyPreviewListeners method




    *[<Null safety>](https://dart.dev/null-safety)*




void notifyPreviewListeners
([HMSPreviewUpdateListenerMethod](../../enum_hms_preview_update_listener_method/HMSPreviewUpdateListenerMethod-class.md) method, [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html), dynamic> arguments)





<p>notifying all previewListeners attached about updates</p>



## Implementation

```dart
static void notifyPreviewListeners(
    HMSPreviewUpdateListenerMethod method, Map<String, dynamic> arguments) {
  switch (method) {
    case HMSPreviewUpdateListenerMethod.onPreviewVideo:
      previewListeners.forEach((e) {
        e.onPreview(
            room: arguments['room'], localTracks: arguments['local_tracks']);
      });
      break;
    case HMSPreviewUpdateListenerMethod.onError:
      previewListeners.forEach((e) {
        e.onError(
            error: arguments["error"]);
      });
      break;
    case HMSPreviewUpdateListenerMethod.unknown:
      break;
  }
}
```







