


# removeMeetingListener method




    *[<Null safety>](https://dart.dev/null-safety)*




void removeMeetingListener
([HMSUpdateListener](../../model_hms_update_listener/HMSUpdateListener-class.md) listener)





<p>remove meetingListener just pass the listener instance you want to remove.</p>



## Implementation

```dart
static void removeMeetingListener(HMSUpdateListener listener) {
  if (meetingListeners.contains(listener)) meetingListeners.remove(listener);
}
```







