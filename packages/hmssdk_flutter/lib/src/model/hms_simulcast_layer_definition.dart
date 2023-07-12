import 'package:hmssdk_flutter/hmssdk_flutter.dart';

/// 100ms HMSSimulcastLayerDefinition
///
/// HMSSimulcastLayerDefinition contains available Simulcast layer and resolution
class HMSSimulcastLayerDefinition {
  /// HMSSimulcastLayer layer enum can be of types - high, mid, low
  HMSSimulcastLayer hmsSimulcastLayer;

  /// HMSResolution defines the width and height of the Video Track
  HMSResolution hmsResolution;

  HMSSimulcastLayerDefinition(
      {required this.hmsSimulcastLayer, required this.hmsResolution});

  factory HMSSimulcastLayerDefinition.fromMap(Map map) {
    return HMSSimulcastLayerDefinition(
        hmsSimulcastLayer: HMSSimulcastLayerValue.getHMSSimulcastLayerFromName(
            map["hms_simulcast_layer"]),
        hmsResolution: HMSResolution.fromMap(map["hms_resolution"]));
  }
}
