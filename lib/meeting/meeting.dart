import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/model/hms_config.dart';
import 'package:hmssdk_flutter/model/platform_method_response.dart';
import 'package:hmssdk_flutter/service/platform_service.dart';

class HMSMeeting {
  Future<void> startMeeting({required HMSConfig config}) async {
    return await PlatformService.invokeMethod(PlatformMethod.joinMeeting,
        arguments: config.getJson());
  }

  Stream<PlatformMethodResponse> startListening() {
    return PlatformService.listenToPlatformCalls();
  }

  Future<void> leaveMeeting() async {
    return await PlatformService.invokeMethod(PlatformMethod.leaveMeeting);
  }

  Future<void> switchAudio({bool isOn = false}) async {
    return await PlatformService.invokeMethod(PlatformMethod.switchAudio,
        arguments: {'is_on': isOn});
  }

  Future<void> switchVideo({bool isOn = false}) async {
    return await PlatformService.invokeMethod(PlatformMethod.switchVideo,
        arguments: {'is_on': isOn});
  }

  Future<void> switchCamera() async {
    return await PlatformService.invokeMethod(
      PlatformMethod.switchCamera,
    );
  }

  Future<void> sendMessage(String message) async{
    return await PlatformService.invokeMethod(PlatformMethod.sendMessage,arguments: {"message":message});
  }
}
