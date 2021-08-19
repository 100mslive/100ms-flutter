


# removePreviewListener method




    *[<Null safety>](https://dart.dev/null-safety)*




void removePreviewListener
([HMSPreviewListener](../../model_hms_preview_listener/HMSPreviewListener-class.md) listener)





<p>remove previewListener just pass the listener instance you want to remove.</p>



## Implementation

```dart
static void removePreviewListener(HMSPreviewListener listener) {
  if (previewListeners.contains(listener)) previewListeners.remove(listener);
}
```







