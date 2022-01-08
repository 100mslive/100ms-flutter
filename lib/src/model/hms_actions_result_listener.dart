// Project imports:
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';

abstract class HMSActionResultListener {
  void onSuccess(String? methodType);

  void onError({HMSException? hmsException});
} 
