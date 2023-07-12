// Project imports:
import '../../hmssdk_flutter.dart';

abstract class HMSMessageResultListener {
  void onSuccess({required HMSMessage hmsMessage});

  void onError({HMSException? hmsException});
}
