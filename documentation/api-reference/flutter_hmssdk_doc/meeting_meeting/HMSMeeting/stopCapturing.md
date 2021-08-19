


# stopCapturing method




    *[<Null safety>](https://dart.dev/null-safety)*




void stopCapturing
()





<p>it will stop capturing the local video.</p>



## Implementation

```dart
void stopCapturing() {
  PlatformService.invokeMethod(PlatformMethod.stopCapturing);
}
```







