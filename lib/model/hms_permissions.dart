class HMSPermissions {
  final bool endRoom;
  final bool removeOthers;
  final bool stopPresentation;
  final bool muteAll;
  final bool askToUnMute;
  final bool muteSelective;
  final bool changeRole;

  HMSPermissions(
      {required this.endRoom,
      required this.removeOthers,
      required this.stopPresentation,
      required this.muteAll,
      required this.askToUnMute,
      required this.muteSelective,
      required this.changeRole});

  factory HMSPermissions.fromMap(Map map) {
    return HMSPermissions(
        endRoom: map['end_room'],
        removeOthers: map['remove_others'],
        stopPresentation: map['stop_presentation'],
        muteAll: map['mute_all'],
        askToUnMute: map['ask_to_un_mute'],
        muteSelective: map['mute_selective'],
        changeRole: map['change_role']);
  }
}
