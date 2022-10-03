class HMSSessionMetadata {
  final String metadata;

  HMSSessionMetadata({required this.metadata});

  factory HMSSessionMetadata.fromMap(Map map) {
    return HMSSessionMetadata(metadata: map["data"]["metadata"]);
  }
}
