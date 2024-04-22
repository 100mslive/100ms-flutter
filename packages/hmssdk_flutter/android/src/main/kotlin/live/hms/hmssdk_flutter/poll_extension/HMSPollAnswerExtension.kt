package live.hms.hmssdk_flutter.poll_extension

import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.poll_extension.HMSPollQuestionExtension.Companion.getStringFromPollQuestionType
import live.hms.video.polls.models.answer.HmsPollAnswer

class HMSPollAnswerExtension {
    companion object {
        fun toDictionary(answer: HmsPollAnswer?): HashMap<String, Any?>? {
            answer?.let {
                val map = HashMap<String, Any?>()
                map["answer"] = it.answerText
                map["duration"] = it.durationMillis
                map["question_id"] = it.questionId
                map["question_type"] = getStringFromPollQuestionType(it.questionType)
                map["selected_option"] = it.selectedOption
                map["selected_options"] = it.selectedOptions
                map["skipped"] = it.skipped
                map["update"] = it.update
                return map
            } ?: run {
                return null
            }
        }

        fun toHMSPollAnswer(answerMap: HashMap<String, Any?>?): HmsPollAnswer? {
            answerMap?.let {
                val answer =
                    answerMap["answer"]?.let {
                        it as String
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("answer should not be null")
                        return null
                    }

                val duration =
                    answerMap["duration"]?.let {
                        (it as Int).toLong()
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("duration should not be null")
                        return null
                    }

                val questionId =
                    answerMap["question_id"]?.let {
                        it as Int
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("questionId should not be null")
                        return null
                    }

                val questionType =
                    answerMap["question_type"]?.let {
                        HMSPollQuestionExtension.getPollQuestionTypeFromString(it as String)
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("questionType should not be null")
                        return null
                    }

                val selectedOption =
                    answerMap["selected_option"]?.let {
                        it as Int
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("selectedOption should not be null")
                        return null
                    }

                val selectedOptions =
                    answerMap["selected_options"]?.let {
                        it as ArrayList<Int>
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("selectedOptions should not be null")
                        return null
                    }

                val skipped =
                    answerMap["skipped"]?.let {
                        it as Boolean
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("skipped should not be null")
                        return null
                    }

                val update =
                    answerMap["update"]?.let {
                        it as Boolean
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("update should not be null")
                        return null
                    }

                return HmsPollAnswer(questionId, questionType, skipped, selectedOption, selectedOptions, answer, update, duration)
            } ?: run {
                return null
            }
        }
    }
}
