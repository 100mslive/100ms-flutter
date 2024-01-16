package live.hms.hmssdk_flutter.poll_extension

import live.hms.video.polls.models.question.HMSPollQuestion
import live.hms.video.polls.models.question.HMSPollQuestionType

class HMSPollQuestionExtension {
    companion object{
        fun toDictionary(question:HMSPollQuestion?):HashMap<String,Any?>?{

                question?.let {
                    val map = HashMap<String,Any?>()
                    map["answer_long_min_length"] = it.answerLongMinLength
                    map["answer_short_min_length"] = it.answerShortMinLength
                    map["can_change_response"] = it.canChangeResponse
                    map["can_skip"] = it.canSkip
                    map["correct_answer"] = HMSPollQuestionAnswerExtension.toDictionary(it.correctAnswer)
                    map["duration"] = it.duration
                    map["my_responses"] = it.myResponses.forEach{answer -> HMSPollAnswerExtension.toDictionary(answer)}
                    map["negative"] = it.negative
                    val options = ArrayList<HashMap<String,Any?>?>()
                    it.options?.forEach{
                            option -> options.add(HMSPollQuestionOptionExtension.toDictionary(option))
                    }
                    map["options"] = options
                    map["question_id"] = it.questionID
                    map["text"] = it.text
                    map["total"] =  it.total
                    map["type"] = getPollQuestionType(it.type)
                    map["voted"] = it.voted
                    map["weight"] = it.weight
                    return map
                }?:run {
                    return  null
                }
            }

        fun getPollQuestionType(pollQuestionType: HMSPollQuestionType):String?{
            return when(pollQuestionType){
                HMSPollQuestionType.multiChoice -> "multi_choice"
                HMSPollQuestionType.shortAnswer -> "short_answer"
                HMSPollQuestionType.longAnswer -> "long_answer"
                HMSPollQuestionType.singleChoice -> "single_choice"
                else -> null
            }
        }
    }
}