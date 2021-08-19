


# HMSRole.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSRole.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
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
```







