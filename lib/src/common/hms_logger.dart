import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_logs_update_listener.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

void logException(PlatformMethod method, dynamic exception) {
  PlatformService.notifyLogsUpdateListeners(
      HMSLogsUpdateListenerMethod.onLogsUpdate,
      ["HMSException occured in ${method.name} Exception: $exception"]);
}
