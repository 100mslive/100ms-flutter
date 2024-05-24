import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hmssdk_flutter_example/main.dart';

///[ForegroundTaskHandler] is a class that extends [TaskHandler]
///This class is used to handle the foreground task
class ForegroundTaskHandler extends TaskHandler {
  SendPort? _sendPort;

  // Called when the task is started.
  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
  }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    // Send data to the main isolate.
    sendPort?.send(timestamp);
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {}

  // Called when the notification button on the Android platform is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed >> $id');
  }

  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}

///[initForegroundTask] initializes the foreground task
Future<bool> initForegroundTask() async {
  bool isPermissionsGiven = await Utilities.getPermissions();
  if (isPermissionsGiven) {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
          foregroundServiceType: AndroidForegroundServiceType.CAMERA,
          channelId: '100ms_flutter_notification',
          channelName: '100ms Flutter Notification',
          channelDescription:
              'This notification appears when the foreground service is running.',
          channelImportance: NotificationChannelImportance.LOW,
          priority: NotificationPriority.LOW,
          iconData: NotificationIconData(
              resType: ResourceType.mipmap,
              resPrefix: ResourcePrefix.ic,
              name: "launcher")),
      iosNotificationOptions:
          const IOSNotificationOptions(showNotification: false),
      foregroundTaskOptions: const ForegroundTaskOptions(),
    );

    ///[startService] starts the foreground task
    FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback);
    return true;
  }
  return false;
}

///[stopForegroundTask] stops the foreground task
///Called in onLeave callback
void stopForegroundTask() {
  FlutterForegroundTask.stopService();
}
