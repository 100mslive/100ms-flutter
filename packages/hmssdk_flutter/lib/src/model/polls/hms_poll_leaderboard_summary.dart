class HMSPollLeaderboardSummary {
  final double? averageScore;
  final Duration? averageTime;
  final int? respondedCorrectlyPeersCount;
  final int? respondedPeersCount;
  final int? totalPeersCount;

  HMSPollLeaderboardSummary(
      {required this.averageScore,
      required this.averageTime,
      required this.respondedCorrectlyPeersCount,
      required this.respondedPeersCount,
      required this.totalPeersCount});

  factory HMSPollLeaderboardSummary.fromMap(Map map) {
    return HMSPollLeaderboardSummary(
        averageScore: map["average_score"],
        averageTime: map["average_time"] != null
            ? Duration(milliseconds: map["average_time"].toInt())
            : null,
        respondedCorrectlyPeersCount: map["responded_correctly_peers_count"],
        respondedPeersCount: map["responded_peers_count"],
        totalPeersCount: map["total_peers_count"]);
  }
}
