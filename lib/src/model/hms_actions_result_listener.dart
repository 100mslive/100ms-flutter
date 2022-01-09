// Project imports:
import 'package:hmssdk_flutter/src/enum/hms_action_result_listener_method.dart';
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';

abstract class HMSActionResultListener {
  void onSuccess({HMSActionResultListenerMethod methodType, dynamic arguments});

  void onError({HMSActionResultListenerMethod methodType,HMSException? hmsException});
}
