class HMSSimulcastLayerSettingsPolicy {
  final String rid;
  double? scaleResolutionDownBy;
  int? maxBitrate;
  int? maxFramerate;

  HMSSimulcastLayerSettingsPolicy(
      {required this.rid,
      this.scaleResolutionDownBy,
      this.maxBitrate,
      this.maxFramerate});

  factory HMSSimulcastLayerSettingsPolicy.fromMap(Map map) {
    return HMSSimulcastLayerSettingsPolicy(
        rid: map["rid"],
        scaleResolutionDownBy: map["scale_resolution_down_by"],
        maxBitrate: map["max_bitrate"],
        maxFramerate: map["max_framerate"]);
  }
}
