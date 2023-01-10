import 'package:hmssdk_flutter/src/enum/hms_quality_limitation_reason.dart';

class HMSQualityLimitationReasons {
  double? bandWidth;
  double? cpu;
  double? other;
  double? none;
  double? qualityLimitationResolutionChanges;
  HMSQualityLimitationReason reason;

  HMSQualityLimitationReasons(
      {required this.reason,
      this.bandWidth,
      this.cpu,
      this.other,
      this.none,
      this.qualityLimitationResolutionChanges});

  factory HMSQualityLimitationReasons.fromMap(Map map) {
    return HMSQualityLimitationReasons(
        reason: HMSQualityLimitationReasonValue
            .getHMSQualityLimitationReasonFromName(map["reason"]),
        bandWidth: map["band_width"],
        cpu: map["cpu"],
        other: map["other"],
        none: map["none"],
        qualityLimitationResolutionChanges:
            map["quality_limitation_resolution_changes"]);
  }
}
