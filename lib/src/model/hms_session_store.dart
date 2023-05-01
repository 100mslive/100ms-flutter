import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_key_change_observer.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

/// [HMSSessionStore] class takes care of the session metadata for a session
///
/// HMSUpdateListener's [onSessionStoreAvailable] method returns a object of [HMSSessionStore]
/// which can be used to call session metadata methods
///
class HMSSessionStore {
  ///[addKeyChangeListener] method is used to attach listener to particular keys
  ///
  /// **Parameters**:
  ///
  /// **keys** A list of keys to be listened
  ///
  /// **hmsKeyChangeListener** An instance of [HMSKeyChangeListener] implemented in the class where changes needs to be listened
  ///
  Future<HMSException?> addKeyChangeListener(
      {required List<String> keys,
      required HMSKeyChangeListener hmsKeyChangeListener}) async {
    String uid = DateTime.now().millisecondsSinceEpoch.toString();
    dynamic result = await PlatformService.invokeMethod(
        PlatformMethod.addKeyChangeListener,
        arguments: {"keys": keys, "uid": uid});
    if (result == null) {
      PlatformService.addKeyChangeObserver(HMSKeyChangeObserver(
          uid: uid, hmsKeyChangeListener: hmsKeyChangeListener));
      return null;
    } else {
      return HMSException.fromMap(result["data"]);
    }
  }

  ///[removeKeyChangeListener] method is used to remove a key change listener
  ///
  /// **Parameters**:
  ///
  /// **hmsKeyChangeListener** An instance of [HMSKeyChangeListener] which was attaced earlier in [addKeyChangeListener]
  ///
  void removeKeyChangeListener(
      {required HMSKeyChangeListener hmsKeyChangeListener}) {
    PlatformService.removeKeyChangeObserver(hmsKeyChangeListener);
  }

  ///[getSessionMetadataForKey] method is used to get metadata corresponding to the given key.
  /// If there is no data corresponding to the given key it returns null.
  ///
  /// **Parameters**:
  ///
  /// **key** key for which metadata is required
  ///
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

  ///[setSessionMetadataForKey] is used to set metadata for a particular key
  ///
  /// **Parameters**:
  ///
  /// **key** key for metadata needs to be set
  ///
  /// **data** data corresponding to the given key
  ///
  /// **hmsActionResultListener** [hmsActionResultListener] is a callback instance on which [HMSActionResultListener.onSuccess] and [HMSActionResultListener.onException] will be called.
  ///
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
