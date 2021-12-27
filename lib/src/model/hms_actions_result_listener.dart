// Project imports:
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';

abstract class HMSActionResultListener {
  void onSuccess();

  void onError({HMSException? hmsException});
}
