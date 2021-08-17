class HMSPermissions {
  final bool? endRoom;
  final bool? removeOthers;
  final bool? stopPresentation;
  final bool? muteAll;
  final bool? askToUnMute;
  final bool? muteSelective;
  final bool? changeRole;

  HMSPermissions(
      {this.endRoom,
      this.removeOthers,
      this.stopPresentation,
      this.muteAll,
      this.askToUnMute,
      this.muteSelective,
      this.changeRole});

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

  Map<String, dynamic> toJson() {
    return {
      'end_room': endRoom,
      'stop_presentation': stopPresentation,
      'remove_others': removeOthers,
      'mute_all': muteAll,
      'ask_to_un_mute': askToUnMute,
      'mute_selective': muteSelective,
      'change_role': changeRole
    };
  }
}
