import 'package:hmssdk_flutter/src/enum/hms_Quality_limitation_reason.dart';

class HMSQualityLimitationReasons {
  double? bandWidth;
  double? cpu;
  double? none;
  double? qualityLimitationResolutionChanges;
  double? other;
  HMSQualityLimitationReason reason;

  HMSQualityLimitationReasons(
      {required this.reason,
      this.bandWidth,
      this.cpu,
      this.none,
      this.other,
      this.qualityLimitationResolutionChanges});

  factory HMSQualityLimitationReasons.fromMap(Map map) {
    return HMSQualityLimitationReasons(
        reason: HMSQualityLimitationReasonValue
            .getHMSQualityLimitationReasonFromName(map["reason"]),
        bandWidth: map["band_width"],
        cpu: map["cpu"],
        none: map["none"],
        other: map["other"],
        qualityLimitationResolutionChanges:
            map["quality_limitation_resolution_changes"]);
  }
}
