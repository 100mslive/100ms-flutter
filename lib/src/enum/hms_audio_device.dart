enum HMSAudioDevice {
  SPEAKER_PHONE,
  WIRED_HEADSET,
  EARPIECE,
  BLUETOOTH,
  AUTOMATIC,
  UNKNOWN
}

///Camera facing
extension HMSAudioDeviceValues on HMSAudioDevice {
  static HMSAudioDevice getHMSAudioDeviceFromName(String name) {
    switch (name) {

      ///front camera is being used
      case 'SPEAKER_PHONE':
        return HMSAudioDevice.SPEAKER_PHONE;

      case 'WIRED_HEADSET':
        return HMSAudioDevice.WIRED_HEADSET;

      case 'EARPIECE':
        return HMSAudioDevice.EARPIECE;

      case 'BLUETOOTH':
        return HMSAudioDevice.BLUETOOTH;

      case 'AUTOMATIC':
        return HMSAudioDevice.AUTOMATIC;

      default:
        return HMSAudioDevice.UNKNOWN;
    }
  }

  static String getValueFromHMSAudioDevice(HMSAudioDevice hmsAudioDevice) {
    switch (hmsAudioDevice) {
      case HMSAudioDevice.SPEAKER_PHONE:
        return "SPEAKER_PHONE";
      case HMSAudioDevice.WIRED_HEADSET:
        return "WIRED_HEADSET";
      case HMSAudioDevice.EARPIECE:
        return "EARPIECE";
      case HMSAudioDevice.BLUETOOTH:
        return "BLUETOOTH";
      case HMSAudioDevice.AUTOMATIC:
        return "AUTOMATIC";
      case HMSAudioDevice.UNKNOWN:
        return "UNKNOWN";
    }
  }
}
