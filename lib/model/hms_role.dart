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
    print("HMSROLe ${map}");
    return new HMSRole(
      name: map['name'] as String,
      publishSettings: map['publish_settings'] as String,
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
