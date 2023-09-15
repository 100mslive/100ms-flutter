enum HMSMessageRecipientType { BROADCAST, DIRECT, GROUP, unKnown }

///HMSMessageRecipient
extension HMSMessageRecipientValues on HMSMessageRecipientType {
  static HMSMessageRecipientType getHMSMessageRecipientFromName(String name) {
    switch (name) {
      case 'broadCast':
        return HMSMessageRecipientType.BROADCAST;
      case 'peer':
        return HMSMessageRecipientType.DIRECT;
      case 'roles':
        return HMSMessageRecipientType.GROUP;
      default:
        return HMSMessageRecipientType.unKnown;
    }
  }

  static String getValueFromHMSMessageRecipientType(
      HMSMessageRecipientType hmsMessageRecipientType) {
    switch (hmsMessageRecipientType) {
      case HMSMessageRecipientType.BROADCAST:
        return 'broadCast';
      case HMSMessageRecipientType.GROUP:
        return 'roles';
      case HMSMessageRecipientType.DIRECT:
        return 'peer';
      case HMSMessageRecipientType.unKnown:
        return '';
    }
  }
}
