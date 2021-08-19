class HMSSubscribeSettings {
  final List? subcribesToRoles;
  final int maxSubsBitRate;
  final int? maxDisplayTiles;

  HMSSubscribeSettings(
      {this.subcribesToRoles,
      required this.maxSubsBitRate,
      this.maxDisplayTiles});

  factory HMSSubscribeSettings.fromMap(Map map) {
    return HMSSubscribeSettings(
        maxSubsBitRate: map['max_subs_bit_rate'],
        maxDisplayTiles: map['map_display_tiles'],
        subcribesToRoles: map['subscribe_to_roles']);
  }
}
