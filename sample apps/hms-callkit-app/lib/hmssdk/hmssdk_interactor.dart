//Package imports

import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSSDKInteractor {
  static HMSSDK? hmsSDK;

  HMSSDKInteractor() {
    hmsSDK = HMSSDK();
  }
}
