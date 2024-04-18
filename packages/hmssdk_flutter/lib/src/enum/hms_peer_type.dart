///[HMSPeerType] contains peer types i.e peer joined using SIP or using the application
/// Read more info here: https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/sip
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
