package live.hms.hmssdk_flutter.methods

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.hmssdk_flutter.HMSCommonAction
import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.hmssdk_flutter.HMSSessionMetadataExtension
import live.hms.video.error.HMSException
import live.hms.video.sdk.HMSSDK
import live.hms.video.sdk.HMSSessionMetadataListener

class HMSSessionMetadataAction {
    companion object {
        fun sessionMetadataActions(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK) {
            when (call.method) {
                "get_session_metadata" -> {
                    getSessionMetadata(result, hmssdk)
                }
                "set_session_metadata" -> {
                    setSessionMetadata(call, result, hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun getSessionMetadata(result: MethodChannel.Result, hmssdk: HMSSDK) {
            hmssdk.getSessionMetaData(getSessionMetadataResultListener(result))
        }

        private fun setSessionMetadata(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK) {
            val metadata = call.argument<String>("session_metadata")
            hmssdk.setSessionMetaData(metadata, HMSCommonAction.getActionListener(result))
        }

        private fun getSessionMetadataResultListener(result: MethodChannel.Result) = object:
            HMSSessionMetadataListener {
            override fun onError(error: HMSException) {
                result.success(null)
            }

            override fun onSuccess(sessionMetadata: String?) {
                val args = HashMap<String, Any?>()
                args["event_name"] = "session_metadata"
                args["data"] = HMSSessionMetadataExtension.toDictionary(sessionMetadata)
                if (args["data"] != null)
                    CoroutineScope(Dispatchers.Main).launch {
                        result.success(args)
                    }
            }
        }

    }
}