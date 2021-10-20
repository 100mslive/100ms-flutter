enum HMSCameraFacing { kHMSCameraFacingFront, kHMSCameraFacingBack, unknown }

///Camera facing
extension HMSCameraFacingValues on HMSCameraFacing {
  static HMSCameraFacing getHMSCameraFacingFromName(String name) {
    switch (name) {

      ///front camera is being used
      case 'kHMSCameraFacingFront':
        return HMSCameraFacing.kHMSCameraFacingFront;

      ///rear camera is being used
      case 'kHMSCameraFacingBack':
        return HMSCameraFacing.kHMSCameraFacingBack;

      default:
        return HMSCameraFacing.unknown;
    }
  }

  static String getValueFromHMSCameraFacing(HMSCameraFacing hmsCameraFacing) {
    switch (hmsCameraFacing) {
      case HMSCameraFacing.kHMSCameraFacingFront:
        return 'kHMSCameraFacingFront';
      case HMSCameraFacing.kHMSCameraFacingBack:
        return 'kHMSCameraFacingVideo';
      case HMSCameraFacing.unknown:
        return '';
    }
  }
}
