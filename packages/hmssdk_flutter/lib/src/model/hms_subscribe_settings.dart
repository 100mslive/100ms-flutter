import 'package:hmssdk_flutter/hmssdk_flutter.dart';

/// 100ms HMSSubscribeSettings
///
/// [HMSSubscribeSettings] contains subcribesToRoles, maxSubsBitRate and subscribeDegradationParam.
class HMSSubscribeSettings {
  final List? subcribesToRoles;
  final int maxSubsBitRate;
  final HMSSubscribeDegradationParams? subscribeDegradationParam;

  HMSSubscribeSettings(
      {this.subcribesToRoles,
      required this.maxSubsBitRate,
      this.subscribeDegradationParam});

  factory HMSSubscribeSettings.fromMap(Map map) {
    return HMSSubscribeSettings(
        maxSubsBitRate: map['max_subs_bit_rate'],
        subscribeDegradationParam:
            map.containsKey("subscribe_degradation_param")
                ? HMSSubscribeDegradationParams.fromMap(
                    map['subscribe_degradation_param'])
                : null,
        subcribesToRoles: map['subscribe_to_roles']);
  }
}
