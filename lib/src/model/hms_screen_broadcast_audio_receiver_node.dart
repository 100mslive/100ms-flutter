import 'package:hmssdk_flutter/src/model/hms_audio_node.dart';

///100ms HMSScreenBroadcastAudioReceiverNode
///
///[HMSScreenBroadcastAudioReceiverNode] is required when user want to share audio that's playing on your iPhone with screen share(iOS only).
///
///Refer [Audio sharing in iOS guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing#how-to-share-audio-that-s-playing-on-your-i-phone)
class HMSScreenBroadcastAudioReceiverNode extends HMSAudioNode {
  HMSScreenBroadcastAudioReceiverNode()
      : super("screen_broadcast_audio_receiver_node");
}
