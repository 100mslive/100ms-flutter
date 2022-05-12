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

  PeerTrackNode(
      {required this.peer,
      this.track,
      this.audioTrack,
      required this.uid,
      this.isOffscreen = true,
      this.networkQuality = -1,
      this.stats});

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

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return super == other;
  }
}
