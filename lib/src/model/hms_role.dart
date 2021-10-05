///[Role] is a powerful concept that takes a lot of complexity away in handling permissions and supporting features like breakout rooms.
///
///Each HMSPeer instance has a role property which returns an [HMSRole] instance. You can use this property to do following:
///
///   1.Check what this role is allowed to publish. i.e can it send video (and at what resolution)? can it send audio? can it share screen? Who can this role subscribe to? (eg: student can only see the teacher's video) This is can be discovered by checking publishSettings and subscribeSettings properties.
///
///   2.Check what actions this role can perform. i.e can it change someone else's current role, end meeting, remove someone from the room. This is can be discovered by checking the permissions property.
///
///[HMSRole] contains details about the role.
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

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
      required this.publishSettings,
      required this.subscribeSettings,
      required this.priority,
      this.permissions,
      required this.generalPermissions,
      required this.internalPlugins,
      required this.externalPlugins});

  factory HMSRole.fromMap(Map map) {
    String name = map['name'] as String;

    HMSPublishSetting? publishSetting;
    if (map['publish_settings'] != null) {
      publishSetting = HMSPublishSetting.fromMap(map['publish_settings']);
    }

    HMSSubscribeSettings? subscribeSettings;
    if (map['subscribe_settings'] != null) {
      subscribeSettings =
          HMSSubscribeSettings.fromMap(map['subscribe_settings']);
    }

    HMSPermissions? permissions;
    if (map['permissions'] != null) {
      permissions = HMSPermissions.fromMap(map['permissions']);
    }

    return HMSRole(
      name: name,
      publishSettings: publishSetting,
      subscribeSettings: subscribeSettings,
      priority: map['priority'] as int,
      permissions: permissions,
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
