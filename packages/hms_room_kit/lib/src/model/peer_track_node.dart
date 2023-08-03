//Package Imports
import 'package:flutter/foundation.dart';

//Project Imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/model/rtc_stats.dart';

///This class is used to store the peer and track information
///
///[uid] is the unique id of the peer
///[peer] is the [HMSPeer] object of the peer
///[track] is the [HMSVideoTrack] object of the peer
///[isOffscreen] is used to check if the peer is onscreen or offscreen
///[networkQuality] is the network quality of the peer
///[stats] is the [RTCStats] object of the peer
///[audioLevel] is the audio level of the peer
///[pinTile] is used to check if the peer is pinned or not
///[audioTrack] is the [HMSAudioTrack] object of the peer
class PeerTrackNode extends ChangeNotifier {
  HMSPeer peer;
  String uid;
  HMSVideoTrack? track;
  HMSAudioTrack? audioTrack;
  bool isOffscreen;
  int? networkQuality;
  RTCStats? stats;
  int audioLevel;
  bool pinTile;

  PeerTrackNode(
      {required this.peer,
      this.track,
      this.audioTrack,
      required this.uid,
      this.isOffscreen = true,
      this.networkQuality = -1,
      this.stats,
      this.audioLevel = -1,
      this.pinTile = false});

  @override
  String toString() {
    return 'PeerTrackNode{peerId: ${peer.peerId}, name: ${peer.name}, track: $track}, isVideoOn: $isOffscreen }';
  }

  ///This method is used to notify the listeners
  void notify() {
    notifyListeners();
  }

  ///This method is used to set whether the peer is onscreen or offscreen
  void setOffScreenStatus(bool currentState) {
    isOffscreen = currentState;
    notify();
  }

  ///This method is used to set the audio level for the peer
  void setAudioLevel(int audioLevel) {
    this.audioLevel = audioLevel;
    if (!isOffscreen) {
      notify();
    }
  }

  ///This method is used to set the network quality for the peer
  void setNetworkQuality(int? networkQuality) {
    if (networkQuality != null) {
      this.networkQuality = networkQuality;
      if (!isOffscreen) {
        notify();
      }
    }
  }

  ///This method is used to set the audio stats for the peer
  void setHMSRemoteAudioStats(HMSRemoteAudioStats hmsRemoteAudioStats) {
    stats?.hmsRemoteAudioStats = hmsRemoteAudioStats;
    if (!isOffscreen) {
      notify();
    }
  }

  ///This method is used to set the video stats for the peer
  void setHMSRemoteVideoStats(HMSRemoteVideoStats hmsRemoteVideoStats) {
    stats?.hmsRemoteVideoStats = hmsRemoteVideoStats;
    if (!isOffscreen) {
      notify();
    }
  }

  ///This method is used to set the local video stats for the peer
  void setHMSLocalVideoStats(List<HMSLocalVideoStats> hmsLocalVideoStats) {
    stats?.hmsLocalVideoStats = hmsLocalVideoStats;
    if (!isOffscreen) {
      notify();
    }
  }

  ///This method is used to set the local audio stats for the peer
  void setHMSLocalAudioStats(HMSLocalAudioStats hmsLocalAudioStats) {
    stats?.hmsLocalAudioStats = hmsLocalAudioStats;
    if (!isOffscreen) {
      notify();
    }
  }
}
