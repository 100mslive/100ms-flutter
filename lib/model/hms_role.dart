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
  Map? internalPlugins;
  Map? externalPlugins;

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
    return HMSRole(
      name: map['name'] as String,
      // publishSettings: map['publish_settings'],
      // subscribeSettings: map['subscribe_settings'],
      // permissions: map['permissions'],
      priority: map['priority'] as int,
      // generalPermissions: map['general_permissions'],
      // internalPlugins: map['internal_plugins'],
      // externalPlugins: map['external_plugins'],
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
