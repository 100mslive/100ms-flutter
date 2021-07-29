import 'package:hmssdk_flutter/model/hms_permissions.dart';
import 'package:hmssdk_flutter/model/hms_publish_setting.dart';
import 'package:hmssdk_flutter/model/hms_subscribe_settings.dart';

class HMSRole {
  String name;
  String publishSettings;
  String subscribeSettings;
  String permissions;
  int priority;
  String generalPermissions;
  String internalPlugins;
  String externalPlugins;

  HMSRole(
      {required this.name,
        required this.publishSettings,
        required this.subscribeSettings,
        required this.priority,
        required this.permissions,
        required this.generalPermissions,
        required this.internalPlugins,
        required this.externalPlugins});

  factory HMSRole.fromMap(Map map) {
    return HMSRole(
      name: map['name'] as String,
      publishSettings: (map['publish_settings']),
      subscribeSettings:map['subscribe_settings'],
      priority: map['priority'] as int,
      permissions: (map['permissions']??""),
      generalPermissions: map['general_permissions'],
      internalPlugins: map['internal_plugins'],
      externalPlugins: map['external_plugins'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'publishSettings': this.publishSettings,
      'subscribeSettings': this.subscribeSettings,
      'priority': this.priority,
      'generalPermissions': this.generalPermissions,
      'internalPlugins': this.internalPlugins,
      'externalPlugins': this.externalPlugins,
    };
  }
}
