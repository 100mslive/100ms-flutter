


# getMethodFromName method




    *[<Null safety>](https://dart.dev/null-safety)*




[HMSPreviewUpdateListenerMethod](../../hmssdk_flutter/HMSPreviewUpdateListenerMethod-class.md) getMethodFromName
([String](https://api.flutter.dev/flutter/dart-core/String-class.html) name)








## Implementation

```dart
static HMSPreviewUpdateListenerMethod getMethodFromName(String name) {
  switch (name) {
    case 'preview_video':
      return HMSPreviewUpdateListenerMethod.onPreviewVideo;
    case 'on_error':
      return HMSPreviewUpdateListenerMethod.onError;
    default:
      return HMSPreviewUpdateListenerMethod.unknown;
  }
}
```







