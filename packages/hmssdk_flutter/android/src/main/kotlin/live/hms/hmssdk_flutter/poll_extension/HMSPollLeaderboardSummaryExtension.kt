package live.hms.hmssdk_flutter.poll_extension

import live.hms.video.polls.network.HMSPollLeaderboardSummary

class HMSPollLeaderboardSummaryExtension {
    companion object {
        fun toDictionary(pollLeaderboardSummary: HMSPollLeaderboardSummary?): HashMap<String, Any?>? {
            if (pollLeaderboardSummary == null) {
                return null
            }

            val map = HashMap<String, Any?>()

            map["average_score"] = pollLeaderboardSummary.averageScore
            map["average_time"] = pollLeaderboardSummary.averageTime
            map["responded_peers_count"] = pollLeaderboardSummary.respondedPeersCount
            map["responded_correctly_peers_count"] = pollLeaderboardSummary.respondedCorrectlyPeersCount
            map["total_peers_count"] = pollLeaderboardSummary.totalPeersCount

            return map
        }
    }
}
