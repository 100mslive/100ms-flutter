enum HMSAndroidPhoneCallState {
  DISABLE_MUTE_ON_VOIP_PHONE_CALL_RING,
  ENABLE_MUTE_ON_PHONE_CALL_RING,
}

extension HMSAndroidPhoneCallStateValue on HMSAndroidPhoneCallState {
  static HMSAndroidPhoneCallState getHMSPhoneCallStateFromName(String state) {
    switch (state) {
      case 'ENABLE_MUTE_ON_PHONE_CALL_RING':
        return HMSAndroidPhoneCallState.ENABLE_MUTE_ON_PHONE_CALL_RING;
      default:
        return HMSAndroidPhoneCallState.DISABLE_MUTE_ON_VOIP_PHONE_CALL_RING;
    }
  }

  static String getValuefromHMSPhoneCallState(
      HMSAndroidPhoneCallState? phoneCallState) {
    switch (phoneCallState) {
      case HMSAndroidPhoneCallState.ENABLE_MUTE_ON_PHONE_CALL_RING:
        return 'ENABLE_MUTE_ON_PHONE_CALL_RING';
      default:
        return 'DISABLE_MUTE_ON_VOIP_PHONE_CALL_RING';
    }
  }
}
