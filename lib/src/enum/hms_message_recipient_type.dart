enum HMSMessageRecipientType { BROADCAST, PEER, ROLES, unKnown }

extension HMSMessageRecipientValues on HMSMessageRecipientType {
  static HMSMessageRecipientType getHMSMessageRecipientFromName(String name) {
    switch (name) {
      case 'broadCast':
        return HMSMessageRecipientType.BROADCAST;
      case 'peer':
        return HMSMessageRecipientType.PEER;
      case 'roles':
        return HMSMessageRecipientType.ROLES;
      default:
        return HMSMessageRecipientType.unKnown;
    }
  }

  static String getValueFromHMSMessageRecipientType(
      HMSMessageRecipientType hmsMessageRecipientType) {
    switch (hmsMessageRecipientType) {
      case HMSMessageRecipientType.BROADCAST:
        return 'broadCast';
      case HMSMessageRecipientType.ROLES:
        return 'roles';
      case HMSMessageRecipientType.PEER:
        return 'peer';
      case HMSMessageRecipientType.unKnown:
        return '';
    }
  }
}
