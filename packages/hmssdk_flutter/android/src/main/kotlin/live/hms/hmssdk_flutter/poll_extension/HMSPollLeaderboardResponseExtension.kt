package live.hms.hmssdk_flutter.poll_extension

import live.hms.video.polls.network.PollLeaderboardResponse

class HMSPollLeaderboardResponseExtension {
    companion object {
        fun toDictionary(pollLeaderboardResponse: PollLeaderboardResponse): HashMap<String, Any?> {
            val map = HashMap<String, Any?>()

            val entryMap = ArrayList<HashMap<String, Any?>>()

            pollLeaderboardResponse.entries?.forEach { pollLeaderboardResponse ->
                entryMap.add(HMSPollLeaderboardEntryExtension.toDictionary(pollLeaderboardResponse))
            }

            map["entries"] = entryMap
            map["has_next"] = pollLeaderboardResponse.hasNext
            map["summary"] = HMSPollLeaderboardSummaryExtension.toDictionary(pollLeaderboardResponse.summary)
            return map
        }
    }
}
