package live.hms.hmssdk_flutter.poll_extension

import live.hms.video.polls.models.question.HMSPollQuestion
import live.hms.video.polls.models.question.HMSPollQuestionType

class HMSPollQuestionExtension {
    companion object{
        fun toDictionary(question:HMSPollQuestion?):HashMap<String,Any?>?{

                question?.let {
                    val map = HashMap<String,Any?>()
                    map["can_skip"] = it.canSkip
                    map["correct_answer"] = HMSPollQuestionAnswerExtension.toDictionary(it.correctAnswer)
                    map["duration"] = it.duration

                    val responses = ArrayList<HashMap<String,Any?>?>()
                    it.myResponses.forEach {
                        response -> responses.add(HMSPollAnswerExtension.toDictionary(response))
                    }
                    map["my_responses"] = responses

                    val options = ArrayList<HashMap<String,Any?>?>()
                    it.options?.forEach{
                            option -> options.add(HMSPollQuestionOptionExtension.toDictionary(option))
                    }
                    map["options"] = options

                    map["text"] = it.text
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