// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

/// 100ms HMSPeerRemovedFromPeer
///
///when someone kicks you out or when someone ends the room at that time it is triggered
/// [hmsPeerRemovedFromPeer] it consists info about who removed you and why.
class HMSPeerRemovedFromPeer {
  final HMSPeer? peerWhoRemoved;
  final String reason;
  final bool roomWasEnded;

  HMSPeerRemovedFromPeer(
      {required this.peerWhoRemoved,
      required this.reason,
      required this.roomWasEnded});

  Map<String, dynamic> toMap() {
    return {
      'peer_who_removed': this.peerWhoRemoved,
      'reason': this.reason,
      'room_was_ended': this.roomWasEnded,
    };
  }

  @override
  String toString() {
    return 'HMSPeerRemovedFromPeer{peerWhoRemoved: $peerWhoRemoved, reason: $reason, roomWasEnded: $roomWasEnded}';
  }

  factory HMSPeerRemovedFromPeer.fromMap(Map map) {
    return HMSPeerRemovedFromPeer(
      peerWhoRemoved: map['peer_who_removed'] != null
          ? HMSPeer.fromMap(map['peer_who_removed'])
          : null,
      reason: map['reason'] as String,
      roomWasEnded: map['room_was_ended'] as bool,
    );
  }
}
