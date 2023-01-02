import 'package:hmssdk_flutter/src/model/hms_audio_node.dart';

///100ms HMSAudioMixerSource
///
///[HMSAudioMixerSource] contains array of [HMSAudioNode] for sharing audio in iOS device.
///
///Refer [Audio sharing in iOS guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing#i-os-setup)
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
