///[HMSPeerType] contains peer types i.e peer joined using SIP or using the application
enum HMSPeerType { sip, regular }

extension HMSPeerTypevalues on HMSPeerType {
  static HMSPeerType getPeerTypeFromString(String peerType) {
    switch (peerType) {
      case "sip":
        return HMSPeerType.sip;
      default:
        return HMSPeerType.regular;
    }
  }
}
