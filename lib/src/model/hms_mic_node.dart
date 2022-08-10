import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_audio_node.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSMicNode extends HMSAudioNode {
  HMSMicNode() : super("mic_node");

  void setVolume(double volume) async {
    await PlatformService.invokeMethod(PlatformMethod.pauseAudioShare,
        arguments: {"name": "mic_node", "volume": volume});
  }
}
