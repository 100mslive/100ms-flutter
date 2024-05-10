// Project imports
import 'package:hmssdk_flutter/src/model/whiteboard/hms_whiteboard_model.dart';

abstract class HMSWhiteboardUpdateListener {
  void onWhiteboardStart({required HMSWhiteboardModel hmsWhiteboardModel});
  void onWhiteboardStop({required HMSWhiteboardModel hmsWhiteboardModel});
}
