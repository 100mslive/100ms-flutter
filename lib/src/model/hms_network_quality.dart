///100ms HMSNetworkQuality
///
/// When creating an HMSConfig object to request a preview, set the captureNetworkQualityInPreview to true to measure the user's downlink network quality.
///
/// When available, the information will be returned in onPeerUpdate of the HMSPreviewListener and HMSUpdateListener in the update type HMSPeerUpdate.networkQualityUpdated. It can be retrieved out of the HMSPeer object's networkQuality property.
///
/// Network Quality varies between -1 to 5.
///
/// -1 -> Test timeout.
///
/// 0 -> Very bad network or network check failure.
///
/// 1 -> Poor network.
///
/// 2 -> Bad network.
///
/// 3 -> Average.
///
/// 4 -> Good.
///
/// 5 -> Best.
class HMSNetworkQuality {
  int quality;

  HMSNetworkQuality({required this.quality});

  Map<String, dynamic> toMap() {
    return {
      'quality': this.quality,
    };
  }

  factory HMSNetworkQuality.fromMap(Map map) {
    return HMSNetworkQuality(
      quality: map['quality'] as int,
    );
  }

  @override
  String toString() {
    return 'HMSNetworkQuality{quality: $quality}';
  }
}
