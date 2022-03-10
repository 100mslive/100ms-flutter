package live.hms.hmssdk_flutter
import live.hms.video.sdk.HMSSDK
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.video.error.HMSException
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
            val meetingUrl = call.argument<String>("meeting_url")
            val toRecord = call.argument<Boolean>("to_record")
            val listOfRtmpUrls: List<String> = call.argument<List<String>>("rtmp_urls") ?: listOf()
            hmssdk.startRtmpOrRecording(
                    HMSRecordingConfig(meetingUrl!!, listOfRtmpUrls, toRecord!!),
                    hmsActionResultListener = HMSCommonAction.getActionListener(result)
            )
        }

        private fun stopRtmpAndRecording(result: Result,hmssdk:HMSSDK) {
            hmssdk.stopRtmpAndRecording(hmsActionResultListener = HMSCommonAction.getActionListener(result))
        }

    }
}