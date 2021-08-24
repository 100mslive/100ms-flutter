


# changeRole method




    *[<Null safety>](https://dart.dev/null-safety)*




void changeRole
({required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) peerId, required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) roleName, [bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) forceChange = false})





<p>you can change role of any peer in the room just pass <code>peerId</code> and <code>roleName</code>, <code>forceChange</code> is optional.</p>



## Implementation

```dart
void changeRole(
    {required String peerId,
    required String roleName,
    bool forceChange = false}) {
  PlatformService.invokeMethod(PlatformMethod.changeRole, arguments: {
    'peer_id': peerId,
    'role_name': roleName,
    'force_change': forceChange
  });
}
```







