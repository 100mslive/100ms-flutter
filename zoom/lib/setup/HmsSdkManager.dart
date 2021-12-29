import 'package:zoom/setup/hms_sdk_interactor.dart';

class HmsSdkManager {
  static HMSSDKInteractor? hmsSdkInteractor = HMSSDKInteractor();

  HMSSDKInteractor createInstance() {
    if (HmsSdkManager.hmsSdkInteractor == null) {
      hmsSdkInteractor = HMSSDKInteractor();
    }
    return hmsSdkInteractor!;
  }
}
