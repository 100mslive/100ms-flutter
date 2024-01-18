package live.hms.hmssdk_flutter.poll_extension

import live.hms.video.polls.models.question.HMSPollQuestionOption

class HMSPollQuestionOptionExtension {

    companion object{

        fun toDictionary(pollOptions: HMSPollQuestionOption?): HashMap<String,Any?>?{

            pollOptions?.let {
                val map = HashMap<String,Any?>()
                map["index"] = it.index
                map["text"] = it.text
                map["vote_count"] = it.voteCount
                map["weight"] = it.weight
                return map
            }?:run {
                return null
            }
        }
    }
}