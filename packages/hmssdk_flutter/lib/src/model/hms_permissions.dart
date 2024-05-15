import 'package:hmssdk_flutter/src/model/whiteboard/hms_whiteboard_permission.dart';

///100ms HMSPermissions
///
///[HMSPermissions] contains permissions for local peer like end room, remove others, mute and unmute other peers, role change and other permissions.
class HMSPermissions {
  final bool? browserRecording;
  final bool? changeRole;
  final bool? endRoom;
  final bool? hlsStreaming;
  final bool? mute;
  final bool? removeOthers;
  final bool? rtmpStreaming;
  final bool? unMute;
  final bool? pollRead;
  final bool? pollWrite;
  final HMSWhiteboardPermission? whiteboard;

  HMSPermissions(
      {this.endRoom,
      this.hlsStreaming,
      this.rtmpStreaming,
      this.removeOthers,
      this.browserRecording,
      this.mute,
      this.unMute,
      this.changeRole,
      this.pollRead,
      this.pollWrite,
      this.whiteboard});

  factory HMSPermissions.fromMap(Map map) {
    return HMSPermissions(
        browserRecording: map["browser_recording"],
        changeRole: map['change_role'],
        endRoom: map['end_room'],
        hlsStreaming: map['hls_streaming'],
        mute: map['mute'],
        removeOthers: map['remove_others'],
        rtmpStreaming: map['rtmp_streaming'],
        unMute: map['un_mute'],
        pollRead: map['poll_read'],
        pollWrite: map['poll_write'],
        whiteboard: map['whiteboard_permission'] != null
            ? HMSWhiteboardPermission.fromMap(map['whiteboard_permission'])
            : null);
  }
}
