//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///This class contains the stats of the room
///It contains the stats of the local peer and the remote peers
///
///For more details checkout the [HMSRemoteAudioStats], [HMSLocalVideoStats], [HMSRemoteVideoStats], [HMSLocalAudioStats] classes
class RTCStats {
  HMSRemoteAudioStats? hmsRemoteAudioStats;
  List<HMSLocalVideoStats>? hmsLocalVideoStats;
  HMSRemoteVideoStats? hmsRemoteVideoStats;
  HMSLocalAudioStats? hmsLocalAudioStats;

  RTCStats(
      {this.hmsRemoteVideoStats,
      this.hmsRemoteAudioStats,
      this.hmsLocalAudioStats,
      this.hmsLocalVideoStats});
}
