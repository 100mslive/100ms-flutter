package live.hms.hmssdk_flutter
import live.hms.video.sdk.HMSSDK
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.hmssdk_flutter.HMSErrorLogger.Companion.returnError
import live.hms.video.error.HMSException
import live.hms.video.media.settings.HMSRtmpVideoResolution
import live.hms.video.sdk.HMSActionResultListener
import live.hms.video.sdk.models.HMSRecordingConfig

class HMSRecordingAction {
    companion object{
        fun recordingActions(call: MethodCall, result: Result,hmssdk:HMSSDK){
            when (call.method) {
                "start_rtmp_or_recording" -> {
                    startRtmpOrRecording(call, result,hmssdk)
                }
                "stop_rtmp_and_recording" -> {
                    stopRtmpAndRecording(result,hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun startRtmpOrRecording(call: MethodCall, result: Result,hmssdk:HMSSDK) {
            val meetingUrl = call.argument<String>("meeting_url") ?: returnError("startRtmpOrRecording error meetingUrl is null")
            val toRecord = call.argument<Boolean>("to_record") ?: returnError("startRtmpOrRecording error toRecord is null")
            val listOfRtmpUrls: List<String> = call.argument<List<String>>("rtmp_urls") ?: listOf()
            val resolutionMap = call.argument<Map<String,Int>>("resolution")

            if(meetingUrl != null && toRecord != null){
                val hmsRecordingConfig = if(resolutionMap!=null) {
                    val resolution = HMSRtmpVideoResolution(
                        width = resolutionMap["width"]!!,
                        height = resolutionMap["height"]!!
                    )
                    HMSRecordingConfig(meetingUrl as String, listOfRtmpUrls, toRecord as Boolean,resolution)
                }else{
                    HMSRecordingConfig(meetingUrl as String, listOfRtmpUrls, toRecord as Boolean)
                }
                hmssdk.startRtmpOrRecording(
                    hmsRecordingConfig,
                    hmsActionResultListener = HMSCommonAction.getActionListener(result)
                )
            }
        }

        private fun stopRtmpAndRecording(result: Result,hmssdk:HMSSDK) {
            hmssdk.stopRtmpAndRecording(hmsActionResultListener = HMSCommonAction.getActionListener(result))
        }

    }
}