package live.hms.hmssdk_flutter.poll_extension

import live.hms.video.polls.network.HMSPollLeaderboardEntry

class HMSPollLeaderboardEntryExtension {
    companion object {
        fun toDictionary(hmsPollLeaderboardEntry: HMSPollLeaderboardEntry): HashMap<String, Any?> {
            val map = HashMap<String, Any?>()

            map["correct_responses"] = hmsPollLeaderboardEntry.correctResponses
            map["duration"] = hmsPollLeaderboardEntry.duration
            map["position"] = hmsPollLeaderboardEntry.position
            map["score"] = hmsPollLeaderboardEntry.score
            map["total_responses"] = hmsPollLeaderboardEntry.totalResponses
            map["peer"] = HMSPollResponsePeerInfoExtension.toDictionary(hmsPollLeaderboardEntry.peer)
            return map
        }
    }
}
