import 'package:hmssdk_flutter/model/hms_permissions.dart';
import 'package:hmssdk_flutter/model/hms_publish_setting.dart';
import 'package:hmssdk_flutter/model/hms_subscribe_settings.dart';

class HMSRole {
  String name;
  HMSPublishSetting publishSettings;
  HMSSubscribeSettings subscribeSettings;
  HMSPermissions? permissions;
  int priority;
  Map generalPermissions;
  Map internalPlugins;
  Map externalPlugins;

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
      publishSettings: HMSPublishSetting.fromMap(map['publish_settings']),
      subscribeSettings:
      HMSSubscribeSettings.fromMap(map['subscribe_settings']),
      priority: map['priority'] as int,
      permissions: HMSPermissions.fromMap(map['permissions']),
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
