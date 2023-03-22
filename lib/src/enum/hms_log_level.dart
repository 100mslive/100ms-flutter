enum HMSLogLevel {
  VERBOSE,

  WARN,

  ERROR,

  OFF,

  Unknown
}

///HMSLogLevel for android and ios
extension HMSLogLevelValue on HMSLogLevel {
  static HMSLogLevel getHMSLogLevelFromName(String name) {
    switch (name) {
      case 'verbose':
        return HMSLogLevel.VERBOSE;
      case 'warn':
        return HMSLogLevel.WARN;
      case 'error':
        return HMSLogLevel.ERROR;
      case 'off':
        return HMSLogLevel.OFF;
      default:
        return HMSLogLevel.OFF;
    }
  }

  static String getValueFromHMSLogLevel(HMSLogLevel hmsLogLevel) {
    switch (hmsLogLevel) {
      case HMSLogLevel.VERBOSE:
        return 'verbose';
      case HMSLogLevel.ERROR:
        return 'error';
      case HMSLogLevel.OFF:
        return 'off';
      case HMSLogLevel.WARN:
        return 'warn';
      case HMSLogLevel.Unknown:
        return 'off';
    }
  }
}
