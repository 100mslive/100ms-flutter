class HMSRole {
  String name;
  String publishSettings;
  String subscribeSettings;
  int priority;
  String generalPermissions;
  String internalPlugins;
  String externalPlugins;

  HMSRole(
      {required this.name,
      required this.publishSettings,
      required this.subscribeSettings,
      required this.priority,
      required this.generalPermissions,
      required this.internalPlugins,
      required this.externalPlugins});

  factory HMSRole.fromMap(Map map) {
    return HMSRole(
        name: map['name'],
        publishSettings: map['publish_settings'],
        subscribeSettings: map['subscribe_settings'],
        priority: map['priority'],
        generalPermissions: map['general_permissions'],
        internalPlugins: map['internal_plugins'],
        externalPlugins: map['external_plugins']);
    /*
     "name":role.name,
            "publish_settings":"role.publishSettings",
            "subscribe_settings":"role.subscribeSettings",
            "priority":role.priority,
            "general_permissions":"role.generalPermissions",
            "internal_plugins":"role.internalPlugins",
            "external_plugins":"role.externalPlugins",
    */
  }
}
