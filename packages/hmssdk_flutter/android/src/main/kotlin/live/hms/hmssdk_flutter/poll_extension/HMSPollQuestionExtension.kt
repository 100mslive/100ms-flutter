package live.hms.hmssdk_flutter.poll_extension

import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.video.polls.models.answer.HmsPollAnswer
import live.hms.video.polls.models.question.HMSPollQuestion
import live.hms.video.polls.models.question.HMSPollQuestionOption
import live.hms.video.polls.models.question.HMSPollQuestionType

class HMSPollQuestionExtension {
    companion object {
        fun toDictionary(question: HMSPollQuestion?): HashMap<String, Any?>? {
            question?.let {
                val map = HashMap<String, Any?>()
                map["question_id"] = it.questionID
                map["can_skip"] = it.canSkip
                map["correct_answer"] = HMSPollQuestionAnswerExtension.toDictionary(it.correctAnswer)
                map["duration"] = it.duration

                val responses = ArrayList<HashMap<String, Any?>?>()
                it.myResponses.forEach {
                        response ->
                    responses.add(HMSPollAnswerExtension.toDictionary(response))
                }
                map["my_responses"] = responses

                val options = ArrayList<HashMap<String, Any?>?>()
                it.options?.forEach {
                        option ->
                    options.add(HMSPollQuestionOptionExtension.toDictionary(option))
                }
                map["options"] = options

                map["text"] = it.text
                map["type"] = getStringFromPollQuestionType(it.type)
                map["voted"] = it.voted
                map["weight"] = it.weight
                map["can_change_response"] = it.canChangeResponse
                return map
            } ?: run {
                return null
            }
        }

        fun toHMSPollQuestion(pollQuestion: HashMap<String, Any?>?): HMSPollQuestion? {
            pollQuestion?.let {
                val questionID =
                    pollQuestion["question_id"]?.let {
                        it as Int
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("questionID should not be null")
                        return null
                    }

                val canSkip =
                    pollQuestion["can_skip"]?.let {
                        it as Boolean
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("canSkip should not be null")
                        return null
                    }
                val correctAnswer =
                    pollQuestion["correct_answer"]?.let {
                        HMSPollQuestionAnswerExtension.toPollQuestionAnswer(it as HashMap<String, Any?>?)
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("correctAnswer should not be null")
                        return null
                    }
                val duration =
                    pollQuestion["duration"]?.let {
                        (it as Int).toLong()
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("duration should not be null")
                        return null
                    }

                val myResponses =
                    pollQuestion["my_responses"]?.let {
                        val responses = it as ArrayList<*>
                        val myResponses = ArrayList<HmsPollAnswer>()
                        responses.forEach { response ->
                            val answer = HMSPollAnswerExtension.toHMSPollAnswer(response as HashMap<String, Any?>?)
                            answer?.let { value ->
                                myResponses.add(value)
                            }
                        }
                        myResponses
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("myResponses should not be null")
                        return null
                    }

                val options =
                    pollQuestion["options"]?.let {
                        val options = it as ArrayList<*>
                        val pollOptions = ArrayList<HMSPollQuestionOption>()
                        options.forEach { option ->
                            val pollOption = HMSPollQuestionOptionExtension.toHMSPollQuestionOption(option as HashMap<String, Any?>?)
                            pollOption?.let { value ->
                                pollOptions.add(value)
                            }
                        }
                        pollOptions
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("options should not be null")
                        return null
                    }

                val text =
                    pollQuestion["text"]?.let {
                        it as String
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("text should not be null")
                        return null
                    }

                val type =
                    pollQuestion["type"]?.let {
                        getPollQuestionTypeFromString(it as String)
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("type should not be null")
                        return null
                    }

                val weight =
                    pollQuestion["weight"]?.let {
                        it as Int
                    } ?: run {
                        HMSErrorLogger.returnArgumentsError("weight should not be null")
                        return null
                    }

                return HMSPollQuestion(
                    questionID,
                    type,
                    text,
                    canSkip,
                    false,
                    duration,
                    weight,
                    null,
                    null,
                    options,
                    correctAnswer,
                    false,
                    myResponses,
                )
            } ?: run {
                return null
            }
        }

        fun getStringFromPollQuestionType(pollQuestionType: HMSPollQuestionType): String? {
            return when (pollQuestionType) {
                HMSPollQuestionType.multiChoice -> "multi_choice"
                HMSPollQuestionType.shortAnswer -> "short_answer"
                HMSPollQuestionType.longAnswer -> "long_answer"
                HMSPollQuestionType.singleChoice -> "single_choice"
                else -> null
            }
        }

        fun getPollQuestionTypeFromString(pollQuestionType: String): HMSPollQuestionType? {
            return when (pollQuestionType) {
                "multi_choice" -> HMSPollQuestionType.multiChoice
                "short_answer" -> HMSPollQuestionType.shortAnswer
                "long_answer" -> HMSPollQuestionType.longAnswer
                "single_choice" -> HMSPollQuestionType.singleChoice
                else -> null
            }
        }
    }
}
