package live.hms.hmssdk_flutter.methods

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import live.hms.hmssdk_flutter.HMSCommonAction
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.hmssdk_flutter.HMSResultExtension
import live.hms.hmssdk_flutter.poll_extension.HMSPollBuilderExtension
import live.hms.hmssdk_flutter.poll_extension.HMSPollAnswerResponseExtension
import live.hms.video.error.HMSException
import live.hms.video.polls.HMSPollResponseBuilder
import live.hms.video.polls.models.HmsPoll
import live.hms.video.polls.models.HmsPollState
import live.hms.video.polls.models.answer.PollAnswerResponse
import live.hms.video.polls.models.question.HMSPollQuestion
import live.hms.video.polls.models.question.HMSPollQuestionOption
import live.hms.video.sdk.HMSSDK
import live.hms.video.sdk.HmsTypedActionResultListener

class HMSPollAction {

    companion object{
        fun pollActions(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK, polls: ArrayList<HmsPoll>?){
            when(call.method){
                "quick_start_poll" -> quickStartPoll(call,result,hmssdk)
                "add_single_choice_poll_response" -> addSingleChoicePollResponse(call,result,hmssdk,polls)
                "add_multi_choice_poll_response" -> addMultiChoicePollResponse(call,result,hmssdk,polls)
                "stop_poll" -> stopPoll(call,result,hmssdk,polls)
            }
        }

        private fun quickStartPoll(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK){

            val pollBuilderMap = call.argument<HashMap<String,Any?>?>("poll_builder")

            val pollBuilder = HMSPollBuilderExtension.toHMSPollBuilder(pollBuilderMap,hmssdk)

            pollBuilder?.let {
                hmssdk.getHmsInteractivityCenter().quickStartPoll( pollBuilder, HMSCommonAction.getActionListener(result))
            }?:run{
                HMSErrorLogger.returnArgumentsError("pollBuilder parsing failed")
            }

        }

        private fun addSingleChoicePollResponse(call: MethodCall, methodChannelResult: MethodChannel.Result, hmssdk: HMSSDK, currentPolls: ArrayList<HmsPoll>?){

            val pollId = call.argument<String?>("poll_id")
            val index = call.argument<Int?>("question_index")
            val userId = call.argument<String?>("user_id")
            val answer = call.argument<HashMap<String,Any?>>("answer")

            /*
             * Here we get index for the option selected by the user
             * if the option doesn't exist we return the arguments error
             */
            val optionIndex = answer?.let {
                 it["index"] as Int
            }?:run {
                HMSErrorLogger.returnArgumentsError("Invalid option index")
                return
            }

            /*
             * We fetch the polls which are currently active and find the poll matching the pollId
             * passed from flutter.
             * We use the poll object and find the question which the user has answered based on the
             * index passed from flutter.
             * After getting the question object we use the index from above to get the HMSPollQuestionOption
             * object
             * Finally we build the response builder and add the response.
             *
             * If anywhere the sdk is unable to find the property we return the error
             */
                currentPolls?.find { it.pollId == pollId }?.let {poll ->
                    index?.let {questionIndex ->

                        poll.questions?.get(questionIndex)?.let { currentQuestion ->
                            /*
                             * Here the index needs to be subtracted by 1
                             * since the HMSPollQuestionOption object has indexing with 1
                             */
                            val questionOption = currentQuestion.options?.get(optionIndex - 1)
                            questionOption?.let {selectedOption ->
                                val response = HMSPollResponseBuilder(poll, userId).addResponse(currentQuestion,selectedOption)
                                hmssdk.getHmsInteractivityCenter().add(response, object : HmsTypedActionResultListener<PollAnswerResponse>{
                                    override fun onSuccess(result: PollAnswerResponse) {
                                        methodChannelResult.success(HMSResultExtension.toDictionary(true,HMSPollAnswerResponseExtension.toDictionary(result)))
                                    }
                                    override fun onError(error: HMSException) {
                                        methodChannelResult.success(HMSResultExtension.toDictionary(false,HMSExceptionExtension.toDictionary(error)))
                                    }
                                })
                            }

                        }?:run {
                            HMSErrorLogger.returnArgumentsError("Question not found")
                            return
                        }
                    }?: run {
                        HMSErrorLogger.returnArgumentsError("Incorrect question index")
                        return
                    }
            }?:run {
                HMSErrorLogger.returnArgumentsError("No poll with given pollId found")
                return
            }
        }

        private fun addMultiChoicePollResponse(call: MethodCall, methodChannelResult: MethodChannel.Result, hmssdk: HMSSDK, currentPolls: ArrayList<HmsPoll>?){

            val pollId = call.argument<String?>("poll_id")
            val index = call.argument<Int?>("question_index")
            val userId = call.argument<String?>("user_id")
            val answer = call.argument<ArrayList<HashMap<String,Any?>?>>("answer")

            /*
             * We fetch the polls which are currently active and find the poll matching the pollId
             * passed from flutter.
             * We use the poll object and find the question which the user has answered based on the
             * index passed from flutter.
             * After getting the question object we use the index from above to get the HMSPollQuestionOption
             * object
             * Finally we build the response builder and add the response.
             *
             * If anywhere the sdk is unable to find the property we return the error
             */
            currentPolls?.find { it.pollId == pollId }?.let { poll ->
                index?.let {questionIndex ->
                    poll.questions?.get(questionIndex)?.let { currentQuestion ->
                        val questionOptions = ArrayList<HMSPollQuestionOption>()
                        answer?.forEach { selectedOptions ->
                            selectedOptions as HashMap<String,Any?>
                            /*
                             * Here the index needs to be subtracted by 1
                             * since the HMSPollQuestionOption object has indexing with 1
                             */
                            selectedOptions["index"]?.let {
                                    index ->  index as Int
                                val questionOption = currentQuestion.options?.get(index - 1)
                                questionOption?.let {option ->
                                    questionOptions.add(option)
                                }
                            }
                        }

                        val response = HMSPollResponseBuilder(poll, userId).addResponse(currentQuestion,questionOptions)
                        hmssdk.getHmsInteractivityCenter().add(response, object : HmsTypedActionResultListener<PollAnswerResponse>{
                            override fun onSuccess(result: PollAnswerResponse) {
                                methodChannelResult.success(HMSResultExtension.toDictionary(true,HMSPollAnswerResponseExtension.toDictionary(result)))
                            }
                            override fun onError(error: HMSException) {
                                methodChannelResult.success(HMSResultExtension.toDictionary(false,HMSExceptionExtension.toDictionary(error)))
                            }
                        })

                    }?: run {
                        HMSErrorLogger.returnArgumentsError("Question not found")
                        return
                    }
                }?:run{
                    HMSErrorLogger.returnArgumentsError("Incorrect question index")
                    return
                }

        }?:run {
            HMSErrorLogger.returnArgumentsError("No poll with given pollId found")
            return
            }
        }

        private fun stopPoll(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK, currentPolls: ArrayList<HmsPoll>?){
            val pollId = call.argument<String?>("poll_id")

            val poll = currentPolls?.first{
                it.pollId == pollId
            }?:run {
                HMSErrorLogger.returnArgumentsError("No Poll with given pollId found")
                return
            }
            hmssdk.getHmsInteractivityCenter().stop(poll,HMSCommonAction.getActionListener(result))

        }
    }
}