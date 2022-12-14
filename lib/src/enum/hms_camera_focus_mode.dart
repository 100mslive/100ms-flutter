enum HMSCameraFocusMode { tapToAutoFocus, tapToLockFocus, auto }

///Camera facing
extension HMSCameraFocusModeValues on HMSCameraFocusMode {
  static HMSCameraFocusMode getHMSCameraFacingFromName(String name) {
    switch (name) {

      ///front camera is being used
      case 'focusmodetaptoautofocus':
        return HMSCameraFocusMode.tapToAutoFocus;

      ///rear camera is being used
      case 'focusmodetaptolockfocus':
        return HMSCameraFocusMode.tapToLockFocus;

      case 'focusmodeauto':
        return HMSCameraFocusMode.auto;
      default:
        return HMSCameraFocusMode.auto;
    }
  }

  static String getValueFromHMSCameraFocusMode(
      HMSCameraFocusMode hmsCameraFocusMode) {
    switch (hmsCameraFocusMode) {
      case HMSCameraFocusMode.tapToAutoFocus:
        return 'focusmodetaptoautofocus';
      case HMSCameraFocusMode.tapToLockFocus:
        return 'focusmodetaptolockfocus';
      case HMSCameraFocusMode.auto:
        return 'focusmodeauto';
    }
  }
}
