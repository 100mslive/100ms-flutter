//Package Imports
import 'package:flutter/foundation.dart';

//Project Imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerTrackNode extends ChangeNotifier {
  HMSPeer peer;
  String uid;
  HMSVideoTrack? track;
  HMSAudioTrack? audioTrack;
  bool isOffscreen;

  PeerTrackNode({
    required this.peer,
    this.track,
    this.audioTrack,
    required this.uid,
    this.isOffscreen = true,
  });

  @override
  String toString() {
    return 'PeerTrackNode{peerId: ${peer.peerId}, name: ${peer.name}, track: $track}, isVideoOn: $isOffscreen }';
  }

  void notify() {
    notifyListeners();
  }

  void setOffScreenStatus(bool currentState) {
    isOffscreen = currentState;
    notify();
  }
}
