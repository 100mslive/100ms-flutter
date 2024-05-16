package live.hms.hmssdk_flutter.methods

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.hmssdk_flutter.HMSCommonAction
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.video.sdk.HMSSDK

class HMSWhiteboardAction {
    companion object {
        fun whiteboardActions(
            call: MethodCall,
            result: Result,
            hmssdk: HMSSDK,
        ) {
            when (call.method) {
                "start_whiteboard" -> startWhiteboard(call, result, hmssdk)
                "stop_whiteboard" -> stopWhiteboard(result, hmssdk)
                else -> result.notImplemented()
            }
        }

        private fun startWhiteboard(
            call: MethodCall,
            result: Result,
            hmssdk: HMSSDK,
        ) {
            val title = call.argument<String>("title")

            title?.let {
                hmssdk.getHmsInteractivityCenter().startWhiteboard(it, HMSCommonAction.getActionListener(result))
            } ?: run {
                HMSErrorLogger.returnArgumentsError("title can't be empty")
            }
        }

        private fun stopWhiteboard(
            result: Result,
            hmssdk: HMSSDK,
        ) {
            hmssdk.getHmsInteractivityCenter().stopWhiteboard(HMSCommonAction.getActionListener(result))
        }
    }
}
