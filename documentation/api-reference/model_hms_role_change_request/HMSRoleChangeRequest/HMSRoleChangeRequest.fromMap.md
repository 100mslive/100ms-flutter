


# HMSRoleChangeRequest.fromMap constructor




    *[<Null safety>](https://dart.dev/null-safety)*



HMSRoleChangeRequest.fromMap([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)





## Implementation

```dart
factory HMSRoleChangeRequest.fromMap(Map map) {
  HMSPeer? requestedBy;
  HMSRole suggestedRole;

  if (map.containsKey('requested_by')) {
    requestedBy = HMSPeer.fromMap(map['requested_by']);
  } else {
    throw HMSInSufficientDataException(message: 'No data found for Peer');
  }
  if (map.containsKey('suggested_role')) {
    suggestedRole = HMSRole.fromMap(map['suggested_role']);
  } else {
    throw HMSInSufficientDataException(message: 'No data found for Role');
  }

  return HMSRoleChangeRequest(
      suggestedRole: suggestedRole, suggestedBy: requestedBy);
}
```







