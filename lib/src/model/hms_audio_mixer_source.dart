import 'package:hmssdk_flutter/src/model/hms_audio_node.dart';

class HMSAudioMixerSource {
  final List<HMSAudioNode> node;
  HMSAudioMixerSource({required this.node});

  List<String> toList() {
    List<String> nodeName = [];
    for (HMSAudioNode i in node) {
      nodeName.add(i.toString());
    }
    return nodeName;
  }
}
