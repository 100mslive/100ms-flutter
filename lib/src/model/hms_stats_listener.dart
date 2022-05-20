// Project imports:
import '../../hmssdk_flutter.dart';

abstract class HMSStatsListener {
  /// This callback provides stats for a local audio track.
  void onLocalAudioStats(
      {required HMSLocalAudioStats hmsLocalAudioStats,
      required HMSLocalAudioTrack track,
      required HMSPeer peer});

  /// This callback provides stats for a local video track.
  void onLocalVideoStats(
      {required HMSLocalVideoStats hmsLocalVideoStats,
      required HMSLocalVideoTrack track,
      required HMSPeer peer});

  /// This callback provides stats for a remote audio track.
  void onRemoteAudioStats(
      {required HMSRemoteAudioStats hmsRemoteAudioStats,
      required HMSRemoteAudioTrack track,
      required HMSPeer peer});

  /// This callback provides stats for a remote video track.
  void onRemoteVideoStats(
      {required HMSRemoteVideoStats hmsRemoteVideoStats,
      required HMSRemoteVideoTrack track,
      required HMSPeer peer});

  /// This callback provides combined stats for the session.
  void onRTCStats({
    required HMSRTCStatsReport hmsrtcStatsReport,
  });
}
