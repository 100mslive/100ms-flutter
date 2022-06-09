///100ms HMSHLSRecording
///
///[HMSHLSRecordingConfig] contains a singleFilePerLayer and VOD info.
class HMSHLSRecordingConfig {
  bool singleFilePerLayer;
  bool videoOnDemand;

  HMSHLSRecordingConfig(
      {this.singleFilePerLayer = false, this.videoOnDemand = false});

  Map<String, dynamic> toMap() {
    return {
      'single_file_per_layer': singleFilePerLayer,
      'video_on_demand': videoOnDemand
    };
  }
}
