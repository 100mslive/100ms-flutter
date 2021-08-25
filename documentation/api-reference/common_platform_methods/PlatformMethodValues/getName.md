


# getName method




    *[<Null safety>](https://dart.dev/null-safety)*




[String](https://api.flutter.dev/flutter/dart-core/String-class.html) getName
([PlatformMethod](../../common_platform_methods/PlatformMethod-class.md) method)








## Implementation

```dart
static String getName(PlatformMethod method) {
  switch (method) {
    case PlatformMethod.joinMeeting:
      return 'join_meeting';
    case PlatformMethod.leaveMeeting:
      return 'leave_meeting';
    case PlatformMethod.onLeaveMeeting:
      return 'on_leave_meeting';
    case PlatformMethod.onJoinRoom:
      return 'on_join_room';
    case PlatformMethod.onUpdateRoom:
      return 'on_update_room';
    case PlatformMethod.onPeerUpdate:
      return 'on_peer_update';
    case PlatformMethod.onTrackUpdate:
      return 'on_track_update';
    case PlatformMethod.onError:
      return 'on_error';
    case PlatformMethod.onMessage:
      return 'on_message';
    case PlatformMethod.onUpdateSpeaker:
      return 'on_update_speaker';
    case PlatformMethod.onReconnecting:
      return 'on_re_connecting';
    case PlatformMethod.onReconnected:
      return 'on_re_connected';
    case PlatformMethod.switchAudio:
      return 'switch_audio';
    case PlatformMethod.switchVideo:
      return 'switch_video';
    case PlatformMethod.switchCamera:
      return 'switch_camera';
    case PlatformMethod.isAudioMute:
      return 'is_audio_mute';
    case PlatformMethod.isVideoMute:
      return 'is_video_mute';
    case PlatformMethod.startCapturing:
      return 'start_capturing';
    case PlatformMethod.stopCapturing:
      return 'stop_capturing';
    case PlatformMethod.sendMessage:
      return 'send_message';
    case PlatformMethod.previewVideo:
      return 'preview_video';
    case PlatformMethod.acceptRoleChange:
      return 'accept_role_change';
    case PlatformMethod.changeRole:
      return 'change_role';
    case PlatformMethod.getRoles:
      return 'get_roles';
    case PlatformMethod.unknown:
      return 'unknown';
  }
}
```







