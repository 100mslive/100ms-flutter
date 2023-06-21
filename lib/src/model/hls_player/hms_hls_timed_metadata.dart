///100ms HMSHLSTimedMetadata
///
/// [HMSHLSTimedMetadata] contains data to be sent as metadata for HLS Stream
class HMSHLSTimedMetadata {
  ///[metadata] contains the message/data which can be sent to a HLS Stream
  final String metadata;

  ///[duration] is the time interval for which the metadata is valid
  final int duration;

  HMSHLSTimedMetadata({required this.metadata, this.duration = 1});

  Map<String, dynamic> toMap() {
    return {"metadata": metadata, "duration": duration};
  }
}
