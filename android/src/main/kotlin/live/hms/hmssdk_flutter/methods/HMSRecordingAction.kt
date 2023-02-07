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
            val meetingUrl = call.argument<String>("meeting_url") ?:
                run{
                    HMSErrorLogger.logError("startRtmpOrRecording", "meetingUrl is null", "Parameter Error")
                    result.success(HMSExceptionExtension.getError("meetingUrl is null in startRtmpOrRecording"))
                    return
                }
            val toRecord = call.argument<Boolean>("to_record") ?:
                run{
                    HMSErrorLogger.logError("startRtmpOrRecording", "toRecord is null", "Parameter Error")
                    result.success(HMSExceptionExtension.getError("toRecord is null in startRtmpOrRecording"))
                    return
                }
            val listOfRtmpUrls: List<String> = call.argument<List<String>>("rtmp_urls") ?: listOf()
            val resolutionMap = call.argument<Map<String,Int>>("resolution")

            val hmsRecordingConfig = if(resolutionMap!=null) {
                val resolution = HMSRtmpVideoResolution(
                    width = resolutionMap["width"]!!,
                    height = resolutionMap["height"]!!
                )
                HMSRecordingConfig(meetingUrl, listOfRtmpUrls, toRecord,resolution)
            }else{
                HMSRecordingConfig(meetingUrl, listOfRtmpUrls, toRecord)
            }
            hmssdk.startRtmpOrRecording(
                hmsRecordingConfig,
                hmsActionResultListener = HMSCommonAction.getActionListener(result)
            )
        }

        private fun stopRtmpAndRecording(result: Result,hmssdk:HMSSDK) {
            hmssdk.stopRtmpAndRecording(hmsActionResultListener = HMSCommonAction.getActionListener(result))
        }

    }
}