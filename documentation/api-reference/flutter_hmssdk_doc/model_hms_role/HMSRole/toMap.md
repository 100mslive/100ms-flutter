


# toMap method




    *[<Null safety>](https://dart.dev/null-safety)*




[Map](https://api.flutter.dev/flutter/dart-core/Map-class.html)&lt;[String](https://api.flutter.dev/flutter/dart-core/String-class.html), dynamic> toMap
()








## Implementation

```dart
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
```







