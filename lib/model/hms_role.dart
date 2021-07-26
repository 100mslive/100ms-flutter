class HMSRole {
  String name;
  HMSPublishSetting publishSettings;
  HMSSubscribeSettings subscribeSettings;
  HMSPermissions permissions;
  int priority;
  Map generalPermissions;
  Map internalPlugins;
  Map externalPlugins;

  HMSRole(
      {required this.name,
      this.publishSettings,
      this.subscribeSettings,
      required this.priority,
      this.permissions,
      this.generalPermissions,
      this.internalPlugins,
      this.externalPlugins});

  factory HMSRole.fromMap(Map map) {
\
    return new HMSRole(
      name: map['name'] as String,
      publishSettings: map['publish_settings'] as ,
      subscribeSettings: map['subscribe_settings'] as String,
      priority: map['priority'] as int,
      generalPermissions: map['general_permissions'] ,
      internalPlugins: map['internal_plugins'] as String,
      externalPlugins: map['external_plugins'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': this.name,
      'publishSettings': this.publishSettings,
      'subscribeSettings': this.subscribeSettings,
      'priority': this.priority,
      'generalPermissions': this.generalPermissions,
      'internalPlugins': this.internalPlugins,
      'externalPlugins': this.externalPlugins,
    } as Map<String, dynamic>;
  }
}
