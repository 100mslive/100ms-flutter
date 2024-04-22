package live.hms.hmssdk_flutter.poll_extension

import live.hms.video.polls.models.PollStatsQuestions

class HMSPollStatsQuestionsExtension {
    companion object {
        fun toDictionary(pollStatsQuestions: PollStatsQuestions?): HashMap<String, Any?>? {
            pollStatsQuestions?.let {
                val map = HashMap<String, Any?>()
                map["attempted_times"] = pollStatsQuestions.attemptedTimes
                map["correct"] = pollStatsQuestions.correct
                map["options"] = pollStatsQuestions.options
                map["question_type"] = HMSPollQuestionExtension.getStringFromPollQuestionType(pollStatsQuestions.questionType)
                map["skipped"] = pollStatsQuestions.skipped
                return map
            } ?: run {
                return null
            }
        }
    }
}
