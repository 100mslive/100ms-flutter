import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSSessionStore {
  Future<void> addKeyChangeListener(
      {required List<String> keys,
      required HMSKeyChangeListener hmsKeyChangeListener,
      HMSActionResultListener? hmsActionResultListener}) async {
    dynamic result = await PlatformService.invokeMethod(
        PlatformMethod.addKeyChangeListener,
        arguments: {
          "keys": keys,
        });
    if (hmsActionResultListener != null) {
      if (result == null) {
        PlatformService.addKeyChangeListener(hmsKeyChangeListener);
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.addKeyChangeListener);
      } else {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.addKeyChangeListener,
            hmsException: HMSException.fromMap(result["data"]));
      }
    }
  }

  Future<void> removeKeyChangeListener(
      {required HMSKeyChangeListener hmsKeyChangeListener}) async {
    await PlatformService.invokeMethod(PlatformMethod.removeKeyChangeListener);
    PlatformService.removeKeyChangeListener(hmsKeyChangeListener);
  }

  Future<dynamic> getSessionMetadataForKey({required String key}) async {
    dynamic result = await PlatformService.invokeMethod(
        PlatformMethod.getSessionMetadataForKey,
        arguments: {"key": key});
    if (result["success"]) {
      return result["data"];
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }

  Future<void> setSessionMetadataForKey(
      {required String key,
      required String? data,
      HMSActionResultListener? hmsActionResultListener}) async {
    Map<String, String?> arguments = {
      "key": key,
      "data": data,
    };
    dynamic result = await PlatformService.invokeMethod(
        PlatformMethod.setSessionMetadataForKey,
        arguments: arguments);
    if (hmsActionResultListener != null) {
      if (result == null) {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.setSessionMetadataForKey,
            arguments: arguments);
      } else {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.setSessionMetadataForKey,
            hmsException: HMSException.fromMap(result["error"]));
      }
    }
  }
}
