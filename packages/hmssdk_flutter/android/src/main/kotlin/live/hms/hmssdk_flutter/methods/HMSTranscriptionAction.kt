package live.hms.hmssdk_flutter.methods

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import live.hms.hmssdk_flutter.HMSCommonAction
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HMSTranscriptExtension
import live.hms.video.sdk.HMSSDK

class HMSTranscriptionAction {

    companion object{

        fun transcriptionAction(call: MethodCall,
                                result: MethodChannel.Result,
                                hmssdk: HMSSDK?){
            when(call.method){
                "start_real_time_transcription" -> {
                    startRealTimeTranscription(call,result,hmssdk)
                }
                "stop_real_time_transcription" -> {
                    stopRealTimeTranscription(call,result,hmssdk)
                }
            }
        }

        /**
         * [startRealTimeTranscription] starts the transcription for everyone in the room
         */
        private fun startRealTimeTranscription(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK?){

            val mode = call.argument<String>("mode") as? String

            mode?.let { _mode ->
                val transcriptionMode = HMSTranscriptExtension.getTranscriptionModeFromString(_mode)
                transcriptionMode?.let {
                    hmssdk?.startRealTimeTranscription(it, HMSCommonAction.getActionListener(result))
                }?:run{
                    HMSErrorLogger.logError("startRealTimeTranscription","Mode is null","NULL Error")
                }
            }
        }

        /**
         * [stopRealTimeTranscription] starts the transcription for everyone in the room
         */
        private fun stopRealTimeTranscription(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK?){
            val mode = call.argument<String>("mode") as? String

            mode?.let { _mode ->
                val transcriptionMode = HMSTranscriptExtension.getTranscriptionModeFromString(_mode)
                transcriptionMode?.let {
                    hmssdk?.stopRealTimeTranscription(it, HMSCommonAction.getActionListener(result))
                }?:run{
                    HMSErrorLogger.returnArgumentsError("mode is a required parameter cannot be null")
                }
            }
        }
    }
}