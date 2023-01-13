/// The available types of Simulcast layers which imply High, Medium or Low Video quality
enum HMSSimulcastLayer { high, mid, low }

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
