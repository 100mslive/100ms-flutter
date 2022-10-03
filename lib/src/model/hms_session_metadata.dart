class HMSSessionMetadata {
  final String? metadata;

  HMSSessionMetadata({this.metadata});

  factory HMSSessionMetadata.fromMap(Map map) {
    return HMSSessionMetadata(
        metadata:
            map["data"]["metadata"] != null ? map["data"]["metadata"] : null);
  }
}
