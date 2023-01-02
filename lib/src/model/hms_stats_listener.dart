// Project imports:
import '../../hmssdk_flutter.dart';

///100ms HMSStatsListener
///
///Sometimes you need a way to capture certain metrics related to a call. This may be helpful if you want to tailor the experience to your users or debug issues. Typical metrics of interest are audio/video bitrate, round trip time, total consumed bandwidth and packet loss.
///
///These will be called with a fixed interval of one second after a room has been joined. You can get stats on a per-track basis ( onRemoteAudioStats) or as an overall summary (onRTCStats)
///
///Refer [call stats guide here](https://www.100ms.live/docs/flutter/v2/features/call-stats)
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
