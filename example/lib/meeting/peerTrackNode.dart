import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:mobx/mobx.dart';

@observable
class PeerTracKNode {
  String peerId;
  String name;
  bool isRaiseHand;
  @observable
  HMSVideoTrack? track;
  HMSTrack? audioTrack;
  PeerTracKNode(
      {required this.peerId,
      this.track,
      this.name = "",
      this.audioTrack,
      this.isRaiseHand = false});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeerTracKNode &&
          runtimeType == other.runtimeType &&
          peerId == other.peerId;

  @override
  String toString() {
    return 'PeerTracKNode{peerId: $peerId, name: $name, track: $track}';
  }

  @override
  int get hashCode => peerId.hashCode;
}
