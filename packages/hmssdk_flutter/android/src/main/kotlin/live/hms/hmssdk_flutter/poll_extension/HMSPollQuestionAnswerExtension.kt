package live.hms.hmssdk_flutter.poll_extension

import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.video.polls.models.answer.HMSPollQuestionAnswer

class HMSPollQuestionAnswerExtension {
    companion object {
        fun toDictionary(answer: HMSPollQuestionAnswer?): HashMap<String, Any?>? {
            answer?.let {
                val map = HashMap<String, Any?>()
                map["hidden"] = it.hidden
                map["option"] = it.option
                map["options"] = it.options
                return map
            } ?: run {
                return null
            }
        }

        fun toPollQuestionAnswer(pollQuestionAnswer: HashMap<String, Any?>?): HMSPollQuestionAnswer? {
            pollQuestionAnswer?.let {
                val hidden =
                    pollQuestionAnswer["hidden"]?.let {
                        it as Boolean
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("hidden should not be null")
                        return null
                    }
                val option =
                    pollQuestionAnswer["option"]?.let {
                        it as Int
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("option should not be null")
                        return null
                    }
                val options =
                    pollQuestionAnswer["options"]?.let {
                        it as ArrayList<Int>
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("options should not be null")
                        return null
                    }

                return HMSPollQuestionAnswer(hidden, option, options)
            } ?: run {
                return null
            }
        }
    }
}
