package live.hms.hmssdk_flutter.poll_extension

import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.video.polls.models.answer.PollAnswerResponse

class HMSPollAnswerResponseExtension {
    companion object {
        fun toDictionary(pollAnswerResponse: PollAnswerResponse): HashMap<String, Any?>? {
            val map = HashMap<String, Any?>()
            val resultMapList = ArrayList<HashMap<String, Any?>>()
            pollAnswerResponse.result.forEach {
                val resultMap = HashMap<String, Any?>()
                resultMap["correct"] = it.correct
                resultMap["error"] = HMSExceptionExtension.toDictionary(it.error)
                resultMap["question_index"] = it.questionIndex

                resultMapList.add(resultMap)
            }

            map["result"] = resultMapList

            return map
        }
    }
}
