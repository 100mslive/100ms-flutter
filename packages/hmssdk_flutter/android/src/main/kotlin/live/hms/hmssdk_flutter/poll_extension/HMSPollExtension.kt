package live.hms.hmssdk_flutter.poll_extension

import live.hms.hmssdk_flutter.HMSPeerExtension
import live.hms.video.polls.models.HmsPoll
import live.hms.video.polls.models.HmsPollCategory
import live.hms.video.polls.models.HmsPollUserTrackingMode

class HMSPollExtension {

    companion object {
        fun toDictionary(poll: HmsPoll): HashMap<String, Any?> {

            val map = HashMap<String,Any?>()

            map["anonymous"] = poll.anonymous
            map["category"] = getPollCategory(poll.category)
            map["createdBy"] = HMSPeerExtension.toDictionary(poll.createdBy)
            map["duration"] = poll.duration
            map["mode"] = getPollUserTrackingMode(poll.mode)
            map["poll_id"] = poll.pollId
            map["question_count"] = poll.questionCount

            map["questions"] = poll.questions?.let {
                poll.questions?.forEach{HMSPollQuestionExtension.toDictionary(it)}
            }?:run {
                null
            }

            map["answers"]

            return map
        }

        private fun getPollCategory(pollCategory: HmsPollCategory):String?{
            return when(pollCategory){
                HmsPollCategory.POLL -> "poll"
                HmsPollCategory.QUIZ -> "quiz"
                else -> null
            }
        }

        private fun getPollUserTrackingMode(pollUserTrackingMode: HmsPollUserTrackingMode?):String?{
            return when(pollUserTrackingMode){
                HmsPollUserTrackingMode.USER_ID -> "user_id"
                HmsPollUserTrackingMode.PEER_ID -> "peer_id"
                HmsPollUserTrackingMode.USERNAME -> "username"
                else -> null
            }
        }
    }
}

