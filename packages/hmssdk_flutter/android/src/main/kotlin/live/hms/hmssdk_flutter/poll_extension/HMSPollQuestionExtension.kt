package live.hms.hmssdk_flutter.poll_extension

import live.hms.video.polls.models.question.HMSPollQuestion

class HMSPollQuestionExtension {
    companion object{
        fun toDictionary(question:HMSPollQuestion?):HashMap<String,Any?>?{

                question?.let {
                    val map = HashMap<String,Any?>()
                    map["answer_long_min_length"] = it.answerLongMinLength
                    map["answer_short_min_length"] = it.answerShortMinLength
                    map["can_change_response"] = it.canChangeResponse
                    map["can_skip"] = it.canSkip
                    map["correct_answer"] = HMSPollAnswerExtension.toDictionary(it.correctAnswer)
                    map["duration"] = it.duration
                    map["my_responses"] = it.myResponses.forEach{HMSPollAnswerExtension.toDictionary(it)}

                    return map
                }?:run {
                    return  null
                }
            }
        }
    }
}