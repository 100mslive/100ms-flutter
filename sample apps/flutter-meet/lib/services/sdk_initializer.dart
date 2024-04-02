//Package imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class SdkInitializer {
  static HMSSDK hmssdk = HMSSDK(
      hmsTrackSetting: HMSTrackSetting(
          audioTrackSetting: HMSAudioTrackSetting(
              trackInitialState: HMSTrackInitState.MUTED)));
}
