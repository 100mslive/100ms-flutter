package live.hms.hmssdk_flutter.poll_extension

import live.hms.hmssdk_flutter.HMSPeerExtension
import live.hms.hmssdk_flutter.HMSRoleExtension
import live.hms.video.polls.models.*

class HMSPollExtension {
    companion object {
        fun toDictionary(poll: HmsPoll): HashMap<String, Any?> {
            val map = HashMap<String, Any?>()

            map["anonymous"] = poll.anonymous
            map["category"] = getPollCategory(poll.category)
            map["created_by"] = HMSPeerExtension.toDictionary(poll.createdBy)
            map["duration"] = poll.duration
            map["mode"] = getPollUserTrackingMode(poll.mode)
            map["poll_id"] = poll.pollId
            map["question_count"] = poll.questionCount

            val questions = ArrayList<HashMap<String, Any?>?>()
            poll.questions?.forEach {
                questions.add(HMSPollQuestionExtension.toDictionary(it))
            }
            map["questions"] = questions

            map["result"] = HMSPollResultDisplayExtension.toDictionary(poll.result)

            val rolesThatCanViewResponses = ArrayList<HashMap<String, Any?>?>()
            poll.rolesThatCanViewResponses.forEach {
                rolesThatCanViewResponses.add(HMSRoleExtension.toDictionary(it))
            }
            map["roles_that_can_view_responses"] = rolesThatCanViewResponses

            val rolesThatCanVote = ArrayList<HashMap<String, Any?>?>()
            poll.rolesThatCanVote.forEach {
                rolesThatCanVote.add(HMSRoleExtension.toDictionary(it))
            }
            map["roles_that_can_vote"] = rolesThatCanVote

            map["started_at"] = poll.startedAt * 1000
            map["started_by"] = HMSPeerExtension.toDictionary(poll.startedBy)
            map["state"] = getPollState(poll.state)
            map["stopped_at"] = poll.stoppedAt?.let {
                it * 1000
            } ?: run {
                null
            }
            map["title"] = poll.title

            return map
        }

        private fun getPollCategory(pollCategory: HmsPollCategory): String? {
            return when (pollCategory) {
                HmsPollCategory.POLL -> "poll"
                HmsPollCategory.QUIZ -> "quiz"
                else -> null
            }
        }

        private fun getPollUserTrackingMode(pollUserTrackingMode: HmsPollUserTrackingMode?): String? {
            return when (pollUserTrackingMode) {
                HmsPollUserTrackingMode.USER_ID -> "user_id"
                HmsPollUserTrackingMode.PEER_ID -> "peer_id"
                HmsPollUserTrackingMode.USERNAME -> "username"
                else -> null
            }
        }

        private fun getPollState(pollState: HmsPollState): String? {
            return when (pollState) {
                HmsPollState.CREATED -> "created"
                HmsPollState.STARTED -> "started"
                HmsPollState.STOPPED -> "stopped"
                else -> null
            }
        }

        fun getPollUpdateType(hmsPollUpdateType: HMSPollUpdateType): String? {
            return when (hmsPollUpdateType) {
                HMSPollUpdateType.started -> "started"
                HMSPollUpdateType.stopped -> "stopped"
                HMSPollUpdateType.resultsupdated -> "results_updated"
                else -> null
            }
        }
    }
}
