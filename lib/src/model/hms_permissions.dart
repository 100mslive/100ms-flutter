///100ms HMSPermissions
///
///[HMSPermissions] contains permissions for local peer like end room, remove others, mute and unmute other peers, role change and other permissions.
class HMSPermissions {
  final bool? endRoom;
  final bool? removeOthers;
  final bool? stopPresentation;
  final bool? mute;
  final bool? unMute;
  final bool? changeRoleForce;
  final bool? changeRole;

  HMSPermissions(
      {this.endRoom,
      this.removeOthers,
      this.stopPresentation,
      this.mute,
      this.unMute,
      this.changeRoleForce,
      this.changeRole});

  factory HMSPermissions.fromMap(Map map) {
    return HMSPermissions(
        endRoom: map['end_room'],
        removeOthers: map['remove_others'],
        stopPresentation: map['stop_presentation'],
        mute: map['mute'],
        unMute: map['un_mute'],
        changeRoleForce: map['change_role_force'],
        changeRole: map['change_role']);
  }

  Map<String, dynamic> toJson() {
    return {
      'end_room': endRoom,
      'stop_presentation': stopPresentation,
      'remove_others': removeOthers,
      'mute': mute,
      'un_mute': unMute,
      'change_role_force': changeRoleForce,
      'change_role': changeRole
    };
  }
}
