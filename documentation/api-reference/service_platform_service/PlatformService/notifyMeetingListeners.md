


# notifyMeetingListeners method




    *[<Null safety>](https://dart.dev/null-safety)*




void notifyMeetingListeners
([HMSUpdateListenerMethod](../../enum_hms_update_listener_method/HMSUpdateListenerMethod-class.md) method, [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html), dynamic> arguments)





<p>notifying all meetingListeners attached about updates</p>



## Implementation

```dart
static void notifyMeetingListeners(
    HMSUpdateListenerMethod method, Map<String, dynamic> arguments) {
  switch (method) {
    case HMSUpdateListenerMethod.onJoinRoom:
      meetingListeners.forEach((e) => e.onJoin(room: arguments['room']));
      break;
    case HMSUpdateListenerMethod.onUpdateRoom:
      meetingListeners.forEach((e) => e.onRoomUpdate(
          room: arguments['room'], update: arguments['update']));
      break;
    case HMSUpdateListenerMethod.onPeerUpdate:
      meetingListeners.forEach((e) => e.onPeerUpdate(
          peer: arguments['peer'], update: arguments['update']));
      break;
    case HMSUpdateListenerMethod.onTrackUpdate:
      meetingListeners.forEach((e) => e.onTrackUpdate(
          track: arguments['track'],
          trackUpdate: arguments['update'],
          peer: arguments['peer']));
      break;
    case HMSUpdateListenerMethod.onError:
      meetingListeners.forEach((e) => e.onError(error: arguments['error']));
      break;
    case HMSUpdateListenerMethod.onMessage:
      meetingListeners
          .forEach((e) => e.onMessage(message: arguments['message']));
      break;
    case HMSUpdateListenerMethod.onUpdateSpeaker:
      meetingListeners.forEach(
          (e) => e.onUpdateSpeakers(updateSpeakers: arguments['speakers']));
      break;
    case HMSUpdateListenerMethod.onReconnecting:
      meetingListeners.forEach((e) => e.onReconnecting());
      break;
    case HMSUpdateListenerMethod.onReconnected:
      meetingListeners.forEach((e) => e.onReconnected());
      break;
    case HMSUpdateListenerMethod.onRoleChangeRequest:
      meetingListeners.forEach((e) => e.onRoleChangeRequest(
          roleChangeRequest: arguments['role_change_request']));
      break;
    case HMSUpdateListenerMethod.unknown:
      break;
  }
}
```







