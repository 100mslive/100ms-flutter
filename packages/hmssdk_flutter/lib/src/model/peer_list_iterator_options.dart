/// This class is used to set the options for the [getPeerListIterator] method
/// 
/// [byPeerIds] list of peerIds for which peer list is required
/// 
/// [byRoleName] name of the role for which peer list is required
/// 
/// [limit] maximum number of peers to be returned
class PeerListIteratorOptions {

  /// list of peerIds for which peer list is required
  final List<String>? byPeerIds;

  /// name of the role for which peer list is required
  final String? byRoleName;

  /// maximum number of peers to be returned
  final int limit;

  PeerListIteratorOptions({
    required this.limit,
    this.byPeerIds,
    this.byRoleName,
  });

  Map<String, dynamic> toMap() {
    return {
      'by_peer_ids': this.byPeerIds,
      'by_role_name': this.byRoleName,
      'limit': this.limit,
    };
  }
}
