package live.hms.hmssdk_flutter.poll_extension

import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.video.polls.models.question.HMSPollQuestionOption

class HMSPollQuestionOptionExtension {
    companion object {
        fun toDictionary(pollOptions: HMSPollQuestionOption?): HashMap<String, Any?>? {
            pollOptions?.let {
                val map = HashMap<String, Any?>()
                map["index"] = it.index
                map["text"] = it.text
                map["vote_count"] = it.voteCount
                map["weight"] = it.weight
                return map
            } ?: run {
                return null
            }
        }

        fun toHMSPollQuestionOption(pollQuestionOptionMap: HashMap<String, Any?>?): HMSPollQuestionOption? {
            pollQuestionOptionMap?.let {
                val index =
                    pollQuestionOptionMap["index"]?.let {
                        it as Int
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("index should not be null")
                        return null
                    }

                val text =
                    pollQuestionOptionMap["text"]?.let {
                        it as String
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("text should not be null")
                        return null
                    }

                val voteCount =
                    pollQuestionOptionMap["vote_count"]?.let {
                        (it as Int).toLong()
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("voteCount should not be null")
                        return null
                    }

                val weight =
                    pollQuestionOptionMap["weight"]?.let {
                        it as Int
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("weight should not be null")
                        return null
                    }

                return HMSPollQuestionOption(
                    index,
                    text,
                    weight,
                    case = false,
                    trim = false,
                    voteCount = voteCount,
                )
            } ?: run {
                return null
            }
        }
    }
}
