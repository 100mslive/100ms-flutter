import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/model/hms_config.dart';
import 'package:hmssdk_flutter/service/platform_service.dart';

class HMSMeeting {
  void startMeeting({required HMSConfig config}) {
    PlatformService.invokeMethod(PlatformMethods.joinMeeting,
        arguments: config.getJson());
  }
}
