import 'package:hmssdk_flutter/model/hms_permissions.dart';
import 'package:hmssdk_flutter/model/hms_publish_setting.dart';
import 'package:hmssdk_flutter/model/hms_subscribe_settings.dart';

class HMSRole {
  String name;
  HMSPublishSetting? publishSettings;
  HMSSubscribeSettings? subscribeSettings;
  HMSPermissions? permissions;
  int priority;
  Map? generalPermissions;

  @override
  String toString() {
    return 'HMSRole{name: $name, priority: $priority}';
  }

  Map? internalPlugins;
  Map? externalPlugins;

  HMSRole(
      {required this.name,
      required this.publishSettings,
      required this.subscribeSettings,
      required this.priority,
      this.permissions,
      required this.generalPermissions,
      required this.internalPlugins,
      required this.externalPlugins});

  factory HMSRole.fromMap(Map map) {
    return HMSRole(
      name: map['name'] as String,
      publishSettings: map['publish_settings'] != null
          ? HMSPublishSetting.fromMap(map['publish_settings'])
          : null,
      subscribeSettings: map['subscribe_settings'] != null
          ? HMSSubscribeSettings.fromMap(map['subscribe_settings'])
          : null,
      priority: map['priority'] as int,
      permissions: map['permissions'] != null
          ? HMSPermissions.fromMap(map['permissions'])
          : null,
      generalPermissions: map['general_permissions'] ?? null,
      internalPlugins: map['internal_plugins'] ?? null,
      externalPlugins: map['external_plugins'] ?? null,
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
      'permissions': permissions
    };
  }
}
