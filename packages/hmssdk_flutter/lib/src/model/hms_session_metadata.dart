///100ms HMSSessionMetadata
///
///[HMSSessionMetadata] contain metadata for the current session room.
class HMSSessionMetadata {
  final String? metadata;

  HMSSessionMetadata({this.metadata});

  factory HMSSessionMetadata.fromMap(Map map) {
    return HMSSessionMetadata(
        metadata:
            map["data"]["metadata"] != null ? map["data"]["metadata"] : null);
  }
}
