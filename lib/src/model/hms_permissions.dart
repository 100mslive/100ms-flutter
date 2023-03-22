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

  HMSPermissions(
      {this.endRoom,
      this.hlsStreaming,
      this.rtmpStreaming,
      this.removeOthers,
      this.browserRecording,
      this.mute,
      this.unMute,
      this.changeRole});

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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'end_room': endRoom,
      'browser_recording': browserRecording,
      'remove_others': removeOthers,
      'mute': mute,
      'un_mute': unMute,
      'hls_streaming': hlsStreaming,
      'rtmp_streaming': rtmpStreaming,
      'change_role': changeRole
    };
  }
}
