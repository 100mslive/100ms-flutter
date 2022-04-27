enum HMSLogLevel {
  VERBOSE,

  DEBUG,

  INFO,

  WARN,

  ERROR,

  OFF,

  Unknown
}

///HMSLogLevel for android and ios
extension HMSLogLevelValue on HMSLogLevel {
  static HMSLogLevel getHMSTrackKindFromName(String name) {
    switch (name) {

      ///IOS
      case 'verbose':
        return HMSLogLevel.VERBOSE;

      ///IOS
      case 'debug':
        return HMSLogLevel.DEBUG;

      ///Android
      case 'info':
        return HMSLogLevel.INFO;

      ///Android
      case 'warn':
        return HMSLogLevel.WARN;
      case 'error':
        return HMSLogLevel.ERROR;
      case 'off':
        return HMSLogLevel.OFF;
      default:
        return HMSLogLevel.Unknown;
    }
  }

  static String getValueFromHMSLogLevel(HMSLogLevel hmsLogLevel) {
    switch (hmsLogLevel) {
      case HMSLogLevel.VERBOSE:
        return 'verbose';
      case HMSLogLevel.DEBUG:
        return 'debug';
      case HMSLogLevel.ERROR:
        return 'error';
      case HMSLogLevel.INFO:
        return 'info';
      case HMSLogLevel.OFF:
        return 'off';
      case HMSLogLevel.WARN:
        return 'warn';
      case HMSLogLevel.Unknown:
        return '';
    }
  }
}
