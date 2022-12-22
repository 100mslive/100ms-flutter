///This class provide updates about all the HMSVideoView attached on UI
///Implement this class to listen to these updates
abstract class HMSVideoViewStateChangeListener {
///This will be called when the first frame gets rendered on HMSVideoView
///This gets called only once for the HMSVideoView lifecycle
///- Parameters:
///  - trackId - Gives info about the track whose first frame got rendered on HMSVideoView
  void onFirstFrameRendered({
    required String trackId,
  });


///This will be called whenever the track resolution changes
///This gets called multiple times whenever the resolution of the track changes
///- Parameters:
///  - trackId - Gives info about the track whose first frame got rendered on HMSVideoView
///  - newWidth - The new width of the track
///  - newHeight - The new height of the track
  void onResolutionChange({required String trackId,required int newWidth, required int newHeight});
}
