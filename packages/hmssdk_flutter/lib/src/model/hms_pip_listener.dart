///100ms HMSPIPListener
///
///100ms SDK provides callbacks to the client app about any change in PIP if the HMSPIPListener is attached
///
///Implement this listener in a class where you wish to listen to the PIP changes
///
///To listen to the changes in PIP mode you can listen to onPictureInPictureModeChanged method
abstract class HMSPIPListener{

  ///[onPictureInPictureModeChanged] will be called when the user enters or exits the picture-in-picture mode.
  void onPictureInPictureModeChanged({required bool isInPipMode}){}

}