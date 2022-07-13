enum HMSNetworkUpdateListenerMethod { onNetworkQuality, unknown }

///HMSNetworkUpdate
extension HMSSNetworkUpdateListenerMethodValues
    on HMSNetworkUpdateListenerMethod {
  static HMSNetworkUpdateListenerMethod getMethodFromName(String name) {
    switch (name) {
      case 'on_network_quality':
        return HMSNetworkUpdateListenerMethod.onNetworkQuality;
      default:
        return HMSNetworkUpdateListenerMethod.unknown;
    }
  }
}
