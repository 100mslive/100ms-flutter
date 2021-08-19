


# getMethodFromName method




    *[<Null safety>](https://dart.dev/null-safety)*




[HMSUpdateListenerMethod](../../enum_hms_update_listener_method/HMSUpdateListenerMethod-class.md) getMethodFromName
([String](https://api.flutter.dev/flutter/dart-core/String-class.html) name)








## Implementation

```dart
static HMSUpdateListenerMethod getMethodFromName(String name) {
  switch (name) {
    case 'on_join_room':
      return HMSUpdateListenerMethod.onJoinRoom;
    case 'on_update_room':
      return HMSUpdateListenerMethod.onUpdateRoom;
    case 'on_peer_update':
      return HMSUpdateListenerMethod.onPeerUpdate;
    case 'on_track_update':
      return HMSUpdateListenerMethod.onTrackUpdate;
    case 'on_error':
      return HMSUpdateListenerMethod.onError;
    case 'on_message':
      return HMSUpdateListenerMethod.onMessage;
    case 'on_update_speaker':
      return HMSUpdateListenerMethod.onUpdateSpeaker;
    case 'on_re_connecting':
      return HMSUpdateListenerMethod.onReconnecting;
    case 'on_re_connected':
      return HMSUpdateListenerMethod.onReconnected;
    case 'on_role_change_request':
      return HMSUpdateListenerMethod.onRoleChangeRequest;
    default:
      return HMSUpdateListenerMethod.unknown;
  }
}
```







