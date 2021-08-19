


# getRoles method




    *[<Null safety>](https://dart.dev/null-safety)*




[Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;[List](https://api.flutter.dev/flutter/dart-core/List-class.html)&lt;[HMSRole](../../model_hms_role/HMSRole-class.md)>> getRoles
()





<p>returns all the roles associated with the link used</p>



## Implementation

```dart
Future<List<HMSRole>> getRoles() async {
  List<HMSRole> roles = [];
  var result = await PlatformService.invokeMethod(PlatformMethod.getRoles);
  if (result is Map && result.containsKey('roles')) {
    if (result['roles'] is List) {
      for (var each in (result['roles'] as List)) {
        HMSRole role = HMSRole.fromMap(each);
        roles.add(role);
      }
    }
  }
  return roles;
}
```







