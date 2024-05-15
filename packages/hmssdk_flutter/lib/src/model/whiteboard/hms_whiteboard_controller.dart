// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///[HMSWhiteboardController] class contains methods to control the Whiteboard
class HMSWhiteboardController {
  /// Starts the Whiteboard with the specified [title].
  /// **parameters**:
  ///
  /// **title** - title of the whiteboard
  ///
  /// Refer [Start Whiteboard](https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/whiteboard#start-whiteboard)
  static Future<HMSException?> start({required String title}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.startWhiteboard,
        arguments: {"title": title});

    if (result != null) {
      return HMSException.fromMap(result["error"]);
    } else {
      return null;
    }
  }

  /// Stops the Whiteboard.
  ///
  /// Refer [Stop Whiteboard](https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/whiteboard#stop-whiteboard)
  static Future<HMSException?> stop() async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.stopWhiteboard);

    if (result != null) {
      return HMSException.fromMap(result["error"]);
    } else {
      return null;
    }
  }

  /// Adds an [HMSWhiteboardUpdateListener] to listen for Whiteboard updates.
  ///
  /// **parameters**:
  ///
  /// **listener** - whiteboard update listener to be attached
  ///
  /// Refer [Whiteboard Update Listener](https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/whiteboard#how-to-display-whiteboard)
  static void addHMSWhiteboardUpdateListener(
      {required HMSWhiteboardUpdateListener listener}) {
    PlatformService.addWhiteboardUpdateListener(listener);
  }

  /// Removes an [HMSWhiteboardUpdateListener] that was previously added.
  ///
  /// Refer [Whiteboard Update Listener](https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/whiteboard#how-to-display-whiteboard)
  static void removeHMSWhiteboardUpdateListener() {
    PlatformService.removeWhiteboardUpdateListener();
  }
}
