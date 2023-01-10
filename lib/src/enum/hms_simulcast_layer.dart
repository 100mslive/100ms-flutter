enum HMSSimulcastLayer { high, mid, low }

extension HMSSimulcastLayerValue on HMSSimulcastLayer {
  static HMSSimulcastLayer getHMSSimulcastLayerFromName(String name) {
    switch (name.toLowerCase()) {
      case 'high':
        return HMSSimulcastLayer.high;
      case 'medium':
        return HMSSimulcastLayer.mid;
      case 'low':
        return HMSSimulcastLayer.low;
      default:
        return HMSSimulcastLayer.mid;
    }
  }

  static String getValueFromHMSSimulcastLayer(
      HMSSimulcastLayer hmsSimulcastLayer) {
    switch (hmsSimulcastLayer) {
      case HMSSimulcastLayer.high:
        return 'high';
      case HMSSimulcastLayer.mid:
        return 'medium';
      case HMSSimulcastLayer.low:
        return 'low';
    }
  }
}
