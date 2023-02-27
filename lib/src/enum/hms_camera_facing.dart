enum HMSCameraFacing { FRONT, BACK, unknown }

///Camera facing
extension HMSCameraFacingValues on HMSCameraFacing {
  static HMSCameraFacing getHMSCameraFacingFromName(String name) {
    switch (name) {

      ///front camera is being used
      case 'front':
        return HMSCameraFacing.FRONT;

      ///rear camera is being used
      case 'back':
        return HMSCameraFacing.BACK;

      default:
        return HMSCameraFacing.unknown;
    }
  }

  static String getValueFromHMSCameraFacing(HMSCameraFacing hmsCameraFacing) {
    switch (hmsCameraFacing) {
      case HMSCameraFacing.FRONT:
        return 'front';
      case HMSCameraFacing.BACK:
        return 'back';
      case HMSCameraFacing.unknown:
        return '';
    }
  }
}
