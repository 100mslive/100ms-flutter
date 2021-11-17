
import '../../hmssdk_flutter.dart';

abstract class HMSMessageResultListener{
  void onSuccess({HMSMessage hmsMessage});

  void onError({HMSException? hmsException});
}