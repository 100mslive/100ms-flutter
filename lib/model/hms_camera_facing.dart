enum HMSCameraFacing { kHMSCameraFacingFront, kHMSCameraFacingBack, unknown }

extension HMSCameraFacingValues on HMSCameraFacing {
  static HMSCameraFacing getHMSCameraFacingFromName(String name) {
    switch (name) {
      case 'kHMSCameraFacingFront':
        return HMSCameraFacing.kHMSCameraFacingFront;
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
