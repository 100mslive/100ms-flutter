class HMSPollResponsePeerInfo {
  final String hash;
  final String? peerId;
  final String? userId;
  final String? userName;

  HMSPollResponsePeerInfo(
      {required this.hash,
      required this.peerId,
      required this.userId,
      required this.userName});

  factory HMSPollResponsePeerInfo.fromMap(Map map) {
    return HMSPollResponsePeerInfo(
        hash: map["hash"],
        peerId: map["peer_id"],
        userId: map["user_id"],
        userName: map["username"]);
  }
}
