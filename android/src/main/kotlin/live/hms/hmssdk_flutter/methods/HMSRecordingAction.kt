package live.hms.hmssdk_flutter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.video.media.settings.HMSRtmpVideoResolution
import live.hms.video.sdk.HMSSDK
import live.hms.video.sdk.models.HMSRecordingConfig

class HMSRecordingAction {
    companion object {
        fun recordingActions(call: MethodCall, result: Result, hmssdk: HMSSDK) {
            when (call.method) {
                "start_rtmp_or_recording" -> {
                    startRtmpOrRecording(call, result, hmssdk)
                }
                "stop_rtmp_and_recording" -> {
                    stopRtmpAndRecording(result, hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun startRtmpOrRecording(call: MethodCall, result: Result, hmssdk: HMSSDK) {
            val meetingUrl = call.argument<String>("meeting_url")
            val toRecord = call.argument<Boolean>("to_record") ?: run {
                HMSErrorLogger.returnArgumentsError("toRecord parameter is null")
            }
            toRecord?.let {enableRecording ->

                val listOfRtmpUrls: List<String> = call.argument<List<String>>("rtmp_urls") ?: listOf()
                val resolutionMap = call.argument<Map<String, Int>>("resolution")
                val hmsRecordingConfig = if (resolutionMap != null) {
                    val resolution = HMSRtmpVideoResolution(
                        width = resolutionMap["width"]!!,
                        height = resolutionMap["height"]!!,
                    )
                    HMSRecordingConfig(meetingUrl, listOfRtmpUrls, enableRecording as Boolean, resolution)
                } else {
                    HMSRecordingConfig(meetingUrl, listOfRtmpUrls, enableRecording as Boolean)
                }
                hmssdk.startRtmpOrRecording(
                    hmsRecordingConfig,
                    hmsActionResultListener = HMSCommonAction.getActionListener(result),
                )

            } ?:
            run {
                HMSErrorLogger.returnArgumentsError("toRecord parameter is null")
            }
        }

        private fun stopRtmpAndRecording(result: Result, hmssdk: HMSSDK) {
            hmssdk.stopRtmpAndRecording(hmsActionResultListener = HMSCommonAction.getActionListener(result))
        }
    }
}
