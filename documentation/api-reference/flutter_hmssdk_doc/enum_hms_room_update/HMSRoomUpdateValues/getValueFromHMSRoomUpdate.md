


# getValueFromHMSRoomUpdate method




    *[<Null safety>](https://dart.dev/null-safety)*




[String](https://api.flutter.dev/flutter/dart-core/String-class.html) getValueFromHMSRoomUpdate
([HMSRoomUpdate](../../enum_hms_room_update/HMSRoomUpdate-class.md) hmsRoomUpdate)








## Implementation

```dart
static String getValueFromHMSRoomUpdate(HMSRoomUpdate hmsRoomUpdate) {
  switch (hmsRoomUpdate) {
    case HMSRoomUpdate.HMSRoomUpdateRoomTypeChanged:
      return 'HMSRoomUpdateRoomTypeChanged';
    case HMSRoomUpdate.HMSRoomUpdateMetaDataUpdated:
      return 'HMSRoomUpdate.HMSRoomUpdateMetaDataUpdated';
    case HMSRoomUpdate.unknown:
      return 'unknown';
  }
}
```







