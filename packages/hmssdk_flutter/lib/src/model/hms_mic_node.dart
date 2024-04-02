import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_audio_node.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///100ms HMSMicNode
///
///[HMSMicNode] is required when user want to share audio with audio sharing(iOS only).
///
///Refer [Audio sharing in iOS guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing#i-os-setup)
class HMSMicNode extends HMSAudioNode {
  HMSMicNode() : super("mic_node");

  void setVolume(double volume) async {
    await PlatformService.invokeMethod(PlatformMethod.pauseAudioShare,
        arguments: {"name": "mic_node", "volume": volume});
  }
}
