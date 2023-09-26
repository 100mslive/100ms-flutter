///[HMSPipEventMethod] enum contains the methods which are used to listen to Picture in Picture events.
enum HMSPIPEventMethod {
  onPictureInPictureModeChanged,
  unknown,
}


extension HMSPIPEventMethodValues on HMSPIPEventMethod{
  static HMSPIPEventMethod getMethodFromName(String name){
    switch(name){
      case "on_picture_in_picture_mode_changed":
        return HMSPIPEventMethod.onPictureInPictureModeChanged;
      default:
        return HMSPIPEventMethod.unknown;
    }
  }
}
