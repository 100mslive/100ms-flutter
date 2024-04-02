///Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///100ms HMSPeerListIterator
///
///[HMSPeerListIterator] contains the info about the peer list iterator
///
///[limit] returns the maximum number of peers that can be returned in a single call to next.
///
///[totalCount] returns the total number of peers present with the iterator based on the filters applied with [PeerListIteratorOptions] while making
///[getPeerListIterator] method call
///
///[uid] returns the unique id of the peer list iterator
class HMSPeerListIterator {
  ///maximum number of peers that can be returned in a single call to next
  final int limit;

  ///total number of peers present with the iterator based on the filters applied with [PeerListIteratorOptions] while making
  ///[getPeerListIterator] method call
  int _totalCount;

  ///unique id of the peer list iterator
  final String uid;

  int get totalCount => _totalCount;

  HMSPeerListIterator({
    required this.limit,
    required this.uid,
    required totalCount,
  }) : _totalCount = totalCount;

  factory HMSPeerListIterator.fromMap(Map map) {
    return HMSPeerListIterator(
      limit: map['limit'] ?? 0,
      totalCount: map['total_count'] ?? 0,
      uid: map['uid'] ?? '',
    );
  }

  ///This method is used to check if there are more peers to be returned
  ///
  ///returns [true] if there are more peers to be returned else [false]
  Future<dynamic> hasNext() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.peerListIteratorHasNext,
        arguments: {"uid": uid});
    if (result["success"]) {
      return result["data"];
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }

  ///This method is used to get the next set of peers
  ///
  ///returns a list of [HMSPeer] objects, the number of peers in a single call depends on the
  ///[limit] parameter in [PeerListIteratorOptions] set during the [getPeerListIterator] method call
  Future<dynamic> next() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.peerListIteratorNext,
        arguments: {"uid": uid});
    if (result["success"]) {
      List<HMSPeer> peers = [];
      _totalCount = result["data"]["total_count"];
      for (var peer in result["data"]["peers"]) {
        peers.add(HMSPeer.fromMap(peer));
      }
      return peers;
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }
}
