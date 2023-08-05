enum HMSQualityLimitationReason {
  BANDWIDTH,

  CPU,

  NONE,

  OTHER,

  UNKNOWN
}

///HMSLogLevel for android and ios
extension HMSQualityLimitationReasonValue on HMSQualityLimitationReason {
  static HMSQualityLimitationReason getHMSQualityLimitationReasonFromName(
      String name) {
    switch (name) {
      case 'BANDWIDTH':
        return HMSQualityLimitationReason.BANDWIDTH;
      case 'CPU':
        return HMSQualityLimitationReason.CPU;
      case 'NONE':
        return HMSQualityLimitationReason.NONE;
      case 'OTHER':
        return HMSQualityLimitationReason.OTHER;
      default:
        return HMSQualityLimitationReason.UNKNOWN;
    }
  }

  static String getValueFromHMSQualityLimitationReason(
      HMSQualityLimitationReason hmsQualityLimitationReason) {
    switch (hmsQualityLimitationReason) {
      case HMSQualityLimitationReason.BANDWIDTH:
        return 'BANDWIDTH';
      case HMSQualityLimitationReason.CPU:
        return 'CPU';
      case HMSQualityLimitationReason.NONE:
        return 'NONE';
      case HMSQualityLimitationReason.OTHER:
        return 'OTHER';
      case HMSQualityLimitationReason.UNKNOWN:
        return 'UNKNOWN';
    }
  }
}
