package live.hms.hmssdk_flutter.poll_extension

import live.hms.video.polls.network.PollResultsDisplay

class HMSPollResultDisplayExtension {
    companion object {
        fun toDictionary(pollResultsDisplay: PollResultsDisplay?): HashMap<String, Any?>? {
            pollResultsDisplay?.let {
                val map = HashMap<String, Any?>()

                val questions = ArrayList<HashMap<String, Any?>?>()
                it.questions.forEach { question -> questions.add(HMSPollStatsQuestionsExtension.toDictionary(question)) }
                map["questions"] = questions

                map["total_distinct_users"] = it.totalDistinctUsers
                map["total_responses"] = it.totalResponses
                map["voting_users"] = it.votingUsers

                return map
            } ?: run {
                return null
            }
        }
    }
}
