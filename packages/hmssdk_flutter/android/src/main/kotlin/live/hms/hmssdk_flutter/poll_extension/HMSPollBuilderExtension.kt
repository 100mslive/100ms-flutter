package live.hms.hmssdk_flutter.poll_extension

import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HMSRoleExtension
import live.hms.video.polls.HMSPollBuilder
import live.hms.video.polls.HMSPollQuestionBuilder
import live.hms.video.polls.models.HmsPollCategory
import live.hms.video.polls.models.HmsPollUserTrackingMode
import live.hms.video.polls.models.question.HMSPollQuestion
import live.hms.video.polls.models.question.HMSPollQuestionType
import live.hms.video.sdk.HMSSDK
import live.hms.video.sdk.models.role.HMSRole
import okhttp3.internal.notify

class HMSPollBuilderExtension {

    companion object{

        fun toHMSPollBuilder(pollBuilderMap: HashMap<String,Any?>?,hmssdk: HMSSDK):HMSPollBuilder?{

            pollBuilderMap?.let {
                val pollBuilder = HMSPollBuilder.Builder()
                pollBuilderMap["anonymous"]?.let{
                    pollBuilder.withAnonymous(it as Boolean)
                }
                pollBuilderMap["duration"]?.let {
                    pollBuilder.withDuration(it as Long)
                }
                pollBuilderMap["mode"]?.let {
                    pollBuilder.withUserTrackingMode(getPollUserTrackingModeFromString(it as String))
                }
                pollBuilderMap["poll_category"]?.let {
                    pollBuilder.withCategory(getPollCategoryFromString(it as String))
                }

                pollBuilderMap["poll_id"]?.let {
                    pollBuilder.withPollId(it as String)
                }

                pollBuilderMap["questions"]?.let {
                    val questions = it as ArrayList<*>
                    val pollQuestions = ArrayList<HMSPollQuestionBuilder>()
                    questions.forEach { pollQuestion ->
                        pollQuestion as HashMap<String,Any?>?
                        val pollQuestionBuilder = getPollQuestionBuilder(pollQuestion)
                        pollQuestionBuilder?.let {questionBuilder ->
                            pollBuilder.addQuestion(questionBuilder)
                        }
                    }

                }

                val availableRoles = hmssdk.getRoles()
                pollBuilderMap["roles_that_can_view_responses"]?.let {
                    val roles = it as ArrayList<*>
                    val rolesThatCanViewResponses = ArrayList<HMSRole>()
                    roles.forEach { forEveryRole ->
                        val role = availableRoles.find { role -> role.name == forEveryRole }
                        role?.let { currentRole ->
                            rolesThatCanViewResponses.add(currentRole)
                        }
                    }
                    pollBuilder.withRolesThatCanViewResponses(rolesThatCanViewResponses)
                }

                pollBuilderMap["roles_that_can_vote"]?.let {
                    val roles = it as ArrayList<*>
                    val rolesThatCanVote = ArrayList<HMSRole>()
                    roles.forEach{ forEveryRole ->
                        val role = availableRoles.find { role -> role.name == forEveryRole }
                        role?.let {currentRole ->
                            rolesThatCanVote.add(currentRole)
                        }
                    }
                    pollBuilder.withRolesThatCanVote(rolesThatCanVote)
                }

                pollBuilderMap["title"]?.let {
                    pollBuilder.withTitle(it as String)
                }

                return pollBuilder.build()

            }?: run {
                return null
            }


        }

        private fun getPollCategoryFromString(category: String): HmsPollCategory {
            return when(category) {
                "poll" -> HmsPollCategory.POLL
                "quiz" -> HmsPollCategory.QUIZ
                else -> HmsPollCategory.POLL
            }
        }


        private fun getPollUserTrackingModeFromString(pollUserTrackingMode: String):HmsPollUserTrackingMode{
            return when(pollUserTrackingMode){
                "user_id" -> HmsPollUserTrackingMode.USER_ID
                "peer_id" -> HmsPollUserTrackingMode.PEER_ID
                "username"-> HmsPollUserTrackingMode.USERNAME
                else -> HmsPollUserTrackingMode.USER_ID

            }
        }

        private fun getPollQuestionTypeFromString(pollQuestionType: String): HMSPollQuestionType{
            return when(pollQuestionType){
                "multi_choice" -> HMSPollQuestionType.multiChoice
                "short_answer" -> HMSPollQuestionType.shortAnswer
                "long_answer"  -> HMSPollQuestionType.longAnswer
                "single_choice" -> HMSPollQuestionType.singleChoice
                else -> HMSPollQuestionType.singleChoice
            }
        }

        private fun getPollQuestionBuilder(pollQuestion: HashMap<String,Any?>?):HMSPollQuestionBuilder?{

            val pollQuestionBuilder : HMSPollQuestionBuilder.Builder
            pollQuestion?.let {

                val type = pollQuestion["type"]?.let {type ->
                    getPollQuestionTypeFromString(type as String)
                }?:run{
                    HMSErrorLogger.returnArgumentsError("type should not be null")
                    return null
                }

                type.let {questionType ->
                    pollQuestionBuilder = HMSPollQuestionBuilder.Builder(questionType)
                }

                val canSkip = pollQuestion["can_skip"]?.let {canSkipQuestion ->
                    canSkipQuestion as Boolean
                }

                canSkip?.let { canSkipQuestion ->
                    pollQuestionBuilder.withCanBeSkipped(canSkipQuestion)
                }

                val text = pollQuestion["text"]?.let { text ->
                    text as String
                }

                text?.let {
                    pollQuestionBuilder.withTitle(text)
                }

                val duration = pollQuestion["duration"]?.let { duration ->
                    duration as Long
                }

                duration?.let { duration ->
                    pollQuestionBuilder.withDuration(duration)
                }

                val weight = pollQuestion["weight"]?.let {weight ->
                    weight as Int
                }

                weight?.let {
                    pollQuestionBuilder.withWeight(weight)
                }

                val answerHidden = pollQuestion["answer_hidden"]?.let {answerHidden ->
                    answerHidden as Boolean
                }

                answerHidden?.let {
                    pollQuestionBuilder.withAnswerHidden(answerHidden)
                }

                val maxLength = pollQuestion["max_length"]?.let { maxLength ->
                    maxLength as Long
                }

                maxLength?.let {
                    pollQuestionBuilder.withMaxLength(maxLength)
                }


                val minLength = pollQuestion["min_length"]?.let { minLength ->
                    minLength as Long
                }

                minLength?.let {
                    pollQuestionBuilder.withMinLength(minLength)
                }

                val pollOptions = pollQuestion["poll_options"]?.let { options ->
                    options as ArrayList<String>
                }?:run {
                    HMSErrorLogger.returnArgumentsError("pollOptions should not be null")
                    null
                }

                pollOptions?.let {
                    pollOptions.forEach {
                        pollQuestionBuilder.addOption(it)
                    }
                }

                val option = pollQuestion["options"]?.let { options ->

                    options as ArrayList<HashMap<String,Boolean>>
                    val optionMap = ArrayList<Pair<String,Boolean>>()

                    options.forEach {
                        val text = it["text"] as String?
                        text?.let { optionText ->
                            val isCorrect = it["is_correct"]
                            isCorrect?.let { isCorrectOption ->
                                optionMap.add(Pair(optionText,isCorrectOption))
                            }
                        }
                    }
                    optionMap
                }?:run {
                    HMSErrorLogger.returnArgumentsError("options should not be null")
                    null
                }

                option?.let {
                    option.forEach {
                        pollQuestionBuilder.addQuizOption(it.first,it.second)
                    }
                }

                val canChangeResponse = pollQuestion["can_change_response"]?.let { canChangeResponse ->
                    canChangeResponse as Boolean
                }

                canChangeResponse?.let {
                    pollQuestionBuilder.withCanChangeResponse(it)
                }

                return pollQuestionBuilder.build()

            }?:run{
                return null
            }
        }
    }
}