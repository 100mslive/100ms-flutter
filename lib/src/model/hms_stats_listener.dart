// Project imports:
import '../../hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';


abstract class HMSStatsListener {
  void onLocalAudioStats(
      {required HMSLocalAudioStats hmsLocalAudioStats,
      required HMSLocalAudioTrack track,
      required HMSPeer peer});

  void onLocalVideoStats(
      {required HMSLocalVideoStats hmsLocalVideoStats,
      required HMSLocalVideoTrack track,
      required HMSPeer peer});

  void onRemoteAudioStats(
      {required HMSRemoteAudioStats hmsRemoteAudioStats,
      required HMSRemoteAudioTrack track,
      required HMSPeer peer});

  void onRemoteVideoStats(
      {required HMSRemoteVideoStats hmsRemoteVideoStats,
      required HMSRemoteVideoTrack track,
      required HMSPeer peer});

  void onRTCStats({
    required HMSRTCStatsReport hmsrtcStatsReport,
  });
}