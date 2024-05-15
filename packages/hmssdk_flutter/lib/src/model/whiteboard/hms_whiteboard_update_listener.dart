// Project imports
import 'package:hmssdk_flutter/src/model/whiteboard/hms_whiteboard_model.dart';

///[HMSWhiteboardUpdateListener] is a listener interface which listens to the updates of the whiteboard
///
///Implement this listener in your class to listen to the updates of the whiteboard
abstract class HMSWhiteboardUpdateListener {
  ///[onWhiteboardStart] is called when the whiteboard is started
  void onWhiteboardStart({required HMSWhiteboardModel hmsWhiteboardModel});

  ///[onWhiteboardStop] is called when the whiteboard is stopped
  void onWhiteboardStop({required HMSWhiteboardModel hmsWhiteboardModel});
}
