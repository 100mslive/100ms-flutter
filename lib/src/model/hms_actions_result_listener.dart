// Project imports:
import 'package:hmssdk_flutter/src/enum/hms_action_result_listener_method.dart';
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';

///100ms HMSActionResultListener
///
///Whenever an instance of [HMSActionResultListener] is passed with a method then it's status i.e whether it succeeded or failed can be listened using HMSActionResultListener's onSuccess & onException callbacks respectively.
abstract class HMSActionResultListener {
  void onSuccess(
      {required HMSActionResultListenerMethod methodType,
      Map<String, dynamic>? arguments});

  void onException(
      {required HMSActionResultListenerMethod methodType,
      Map<String, dynamic>? arguments,
      required HMSException hmsException});
}
