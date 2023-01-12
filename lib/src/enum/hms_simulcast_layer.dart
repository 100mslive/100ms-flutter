enum HMSSimulcastLayer { high, mid, low }

///HMSLogLevel for android and ios
extension HMSSimulcastLayerValue on HMSSimulcastLayer {
  static HMSSimulcastLayer getHMSSimulcastLayerFromName(String name) {
    switch (name) {
      case 'high':
        return HMSSimulcastLayer.high;
      case 'mid':
        return HMSSimulcastLayer.mid;
      case 'low':
        return HMSSimulcastLayer.low;
      default:
        return HMSSimulcastLayer.high;
    }
  }

  static String getValueFromHMSSimulcastLayer(
      HMSSimulcastLayer? hmsSimulcastLayer) {
    switch (hmsSimulcastLayer) {
      case HMSSimulcastLayer.high:
        return 'high';
      case HMSSimulcastLayer.mid:
        return 'mid';
      case HMSSimulcastLayer.low:
        return 'low';
      default:
        return 'high';
    }
  }
}
