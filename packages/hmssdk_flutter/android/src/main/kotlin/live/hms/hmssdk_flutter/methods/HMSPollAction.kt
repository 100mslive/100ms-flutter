package live.hms.hmssdk_flutter.methods

import android.app.Activity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import live.hms.hmssdk_flutter.HMSCommonAction
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.poll_extension.HMSPollBuilderExtension
import live.hms.video.polls.HMSPollBuilder
import live.hms.video.sdk.HMSSDK

class HMSPollAction {

    companion object{
        fun pollActions(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK){
            when(call.method){
                "quick_start_poll" -> quickStartPoll(call,result,hmssdk)
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
    }
}