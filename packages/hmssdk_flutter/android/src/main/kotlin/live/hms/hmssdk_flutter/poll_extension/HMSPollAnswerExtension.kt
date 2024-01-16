package live.hms.hmssdk_flutter.poll_extension

import live.hms.hmssdk_flutter.poll_extension.HMSPollQuestionExtension.Companion.getPollQuestionType
import live.hms.video.polls.models.answer.HmsPollAnswer
import live.hms.video.polls.models.question.HMSPollQuestionType

class HMSPollAnswerExtension {

    companion object {

        fun toDictionary(answer: HmsPollAnswer?): HashMap<String, Any?>? {
            answer?.let {
                val map = HashMap<String, Any?>()
                map["answer"] = it.answerText
                map["duration_millis"] = it.durationMillis
                map["question_id"] = it.questionId
                map["question_type"] = getPollQuestionType(it.questionType)
                map["selected_option"] = it.selectedOption
                map["selected_options"] = it.selectedOptions
                map["skipped"] = it.skipped
                map["update"] = it.update
                return map
            } ?: run {
                return null
            }
        }
    }
}