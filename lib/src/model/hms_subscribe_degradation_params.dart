///100ms HMSSubscribeDegradationParams
///
///[HMSSubscribeDegradationParams] contains degradeGracePeriodSeconds, packetLossThreshold and recoverGracePeriodSeconds.

class HMSSubscribeDegradationParams {
  final int degradeGracePeriodSeconds;
  final int packetLossThreshold;
  final int recoverGracePeriodSeconds;
  HMSSubscribeDegradationParams(
      {required this.degradeGracePeriodSeconds,
      required this.packetLossThreshold,
      required this.recoverGracePeriodSeconds});
  factory HMSSubscribeDegradationParams.fromMap(Map map) {
    return HMSSubscribeDegradationParams(
        degradeGracePeriodSeconds: map["degrade_grace_period_seconds"].toInt(),
        packetLossThreshold: map["packet_loss_threshold"].toInt(),
        recoverGracePeriodSeconds: map["recover_grace_period_seconds"].toInt());
  }
}
