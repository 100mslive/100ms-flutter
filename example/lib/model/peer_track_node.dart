//Package Imports
import 'package:flutter/foundation.dart';

//Project Imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/model/rtc_stats.dart';

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

  @override
  int get hashCode => peer.peerId.hashCode;

  void notify() {
    notifyListeners();
  }

  void setOffScreenStatus(bool currentState) {
    this.isOffscreen = currentState;
    notify();
  }

  void setAudioLevel(int audioLevel) {
    this.audioLevel = audioLevel;
    if (!this.isOffscreen) {
      notify();
    }
  }

  void setNetworkQuality(int? networkQuality) {
    if (networkQuality != null) {
      this.networkQuality = networkQuality;
      if (!this.isOffscreen) {
        notify();
      }
    }
  }

  void setHMSRemoteAudioStats(HMSRemoteAudioStats hmsRemoteAudioStats) {
    stats?.hmsRemoteAudioStats = hmsRemoteAudioStats;
    if (!this.isOffscreen) {
      notify();
    }
  }

  void setHMSRemoteVideoStats(HMSRemoteVideoStats hmsRemoteVideoStats) {
    stats?.hmsRemoteVideoStats = hmsRemoteVideoStats;
    if (!this.isOffscreen) {
      notify();
    }
  }

  void setHMSLocalVideoStats(List<HMSLocalVideoStats> hmsLocalVideoStats) {
    stats?.hmsLocalVideoStats = hmsLocalVideoStats;
    if (!this.isOffscreen) {
      notify();
    }
  }

  void setHMSLocalAudioStats(HMSLocalAudioStats hmsLocalAudioStats) {
    stats?.hmsLocalAudioStats = hmsLocalAudioStats;
    if (!this.isOffscreen) {
      notify();
    }
  }

  @override
  bool operator ==(Object other) {
    return super == other;
  }
}
