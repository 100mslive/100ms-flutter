import 'package:hmssdk_flutter/model/hms_permissions.dart';
import 'package:hmssdk_flutter/model/hms_publish_setting.dart';
import 'package:hmssdk_flutter/model/hms_subscribe_settings.dart';

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
      required this.publishSettings,
      required this.subscribeSettings,
      required this.permissions,
      required this.priority,
      required this.generalPermissions,
      required this.internalPlugins,
      required this.externalPlugins});

  factory HMSRole.fromMap(Map map) {
    return HMSRole(
        name: map['name'],
        publishSettings: map['publish_settings'],
        subscribeSettings: map['subscribe_settings'],
        permissions: map['permissions'],
        priority: map['priority'],
        generalPermissions: map['general_permissions'],
        internalPlugins: map['internal_plugins'],
        externalPlugins: map['external_plugins']);
  }
}
