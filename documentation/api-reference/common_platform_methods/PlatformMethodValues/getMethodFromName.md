


# getMethodFromName method




    *[<Null safety>](https://dart.dev/null-safety)*




[PlatformMethod](../../common_platform_methods/PlatformMethod-class.md) getMethodFromName
([String](https://api.flutter.dev/flutter/dart-core/String-class.html) name)








## Implementation

```dart
static PlatformMethod getMethodFromName(String name) {
  switch (name) {
    case 'join_meeting':
      return PlatformMethod.joinMeeting;
    case 'leave_meeting':
      return PlatformMethod.leaveMeeting;
    case 'on_leave_meeting':
      return PlatformMethod.onLeaveMeeting;
    case 'on_join_room':
      return PlatformMethod.onJoinRoom;
    case 'on_update_room':
      return PlatformMethod.onUpdateRoom;
    case 'on_peer_update':
      return PlatformMethod.onPeerUpdate;
    case 'on_track_update':
      return PlatformMethod.onTrackUpdate;
    case 'on_error':
      return PlatformMethod.onError;
    case 'on_message':
      return PlatformMethod.onMessage;
    case 'on_update_speaker':
      return PlatformMethod.onUpdateSpeaker;
    case 'on_re_connecting':
      return PlatformMethod.onReconnecting;
    case 'on_re_connected':
      return PlatformMethod.onReconnected;
    case 'switch_audio':
      return PlatformMethod.switchAudio;
    case 'switch_video':
      return PlatformMethod.switchVideo;
    case 'switch_camera':
      return PlatformMethod.switchCamera;
    case 'is_audio_mute':
      return PlatformMethod.isAudioMute;
    case 'is_video_mute':
      return PlatformMethod.isVideoMute;
    case 'stop_capturing':
      return PlatformMethod.stopCapturing;
    case 'start_capturing':
      return PlatformMethod.startCapturing;
    case 'send_message':
      return PlatformMethod.sendMessage;
    case 'preview_video':
      return PlatformMethod.previewVideo;
    case 'accept_role_change':
      return PlatformMethod.acceptRoleChange;
    case 'change_role':
      return PlatformMethod.changeRole;
    case 'get_roles':
      return PlatformMethod.getRoles;
    default:
      return PlatformMethod.unknown;
  }
}
```







