import 'package:flutter/foundation.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerTrackNode extends ChangeNotifier {
  HMSPeer peer;

  String uid;

  HMSVideoTrack? track;
  HMSAudioTrack? audioTrack;

  bool isVideoOn;

  PeerTrackNode({
    required this.peer,
    this.track,
    this.audioTrack,
    required this.uid,
    required this.isVideoOn,
  });

  @override
  String toString() {
    return 'PeerTrackNode{peerId: ${peer.peerId}, name: ${peer.name}, track: $track}, isVideoOn: $isVideoOn }';
  }

  @override
  int get hashCode => peer.peerId.hashCode;

  void notify() {
    notifyListeners();
  }

  void setIsVideoOn(bool isVideoOn) {
    this.isVideoOn = isVideoOn;
    notify();
  }
}
