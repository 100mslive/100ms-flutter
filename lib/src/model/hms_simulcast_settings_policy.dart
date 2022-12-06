import 'package:hmssdk_flutter/src/model/hms_simulcast_layer_settings_policy.dart';

class HMSSimulcastSettingsPolicy {
  List<HMSSimulcastLayerSettingsPolicy>? layers;

  HMSSimulcastSettingsPolicy({this.layers});

  factory HMSSimulcastSettingsPolicy.fromMap(Map map) {
    if (map.containsKey("layers")) {
      List<HMSSimulcastLayerSettingsPolicy> layers = [];
      for (Map layer in map["layers"]) {
        layers.add(HMSSimulcastLayerSettingsPolicy.fromMap(layer));
      }
      return HMSSimulcastSettingsPolicy(layers: layers);
    } else {
      return HMSSimulcastSettingsPolicy();
    }
  }
}
