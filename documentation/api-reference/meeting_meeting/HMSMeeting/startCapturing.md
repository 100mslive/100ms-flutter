


# startCapturing method




    *[<Null safety>](https://dart.dev/null-safety)*




void startCapturing
()





<p>it will start capturing the local video.</p>



## Implementation

```dart
void startCapturing() {
  PlatformService.invokeMethod(PlatformMethod.startCapturing);
}
```







