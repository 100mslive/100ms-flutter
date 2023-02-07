package live.hms.hmssdk_flutter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.video.sdk.*
import live.hms.video.error.HMSException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.hmssdk_flutter.HMSErrorLogger.Companion.returnError
import live.hms.video.sdk.models.HMSMessage

class HMSMessageAction {
    companion object {
        fun messageActions(call: MethodCall, result: Result,hmssdk:HMSSDK) {
            when (call.method) {
                "send_broadcast_message" -> {
                    sendBroadCastMessage(call, result,hmssdk)
                }
                "send_direct_message" -> {
                    sendDirectMessage(call, result,hmssdk)
                }
                "send_group_message" -> {
                    sendGroupMessage(call, result,hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }


        private fun sendBroadCastMessage(call: MethodCall, result: Result,hmssdk:HMSSDK) {
            val message = call.argument<String>("message") ?:
            run{
                HMSErrorLogger.logError("sendBroadCastMessage", "message is null", "Parameter Error")
                result.success(HMSExceptionExtension.getError("message is null in sendBroadCastMessage"))
                return
            }
            val type = call.argument<String>("type") ?: "chat"
            hmssdk.sendBroadcastMessage(message, type, getMessageResultListener(result))
        }

        private fun sendGroupMessage(call: MethodCall, result: Result,hmssdk:HMSSDK) {
            val message = call.argument<String>("message") ?:
            run{
                HMSErrorLogger.logError("sendGroupMessage", "message is null", "Parameter Error")
                result.success(HMSExceptionExtension.getError("message is null in sendGroupMessage"))
                return
            }
            val roles: List<String>? = call.argument<List<String>>("roles")
            val type = call.argument<String>("type") ?: "chat"

            val hmsRoles = hmssdk.getRoles().filter { roles?.contains(it.name)!! }

            hmssdk.sendGroupMessage(message, type, hmsRoles, getMessageResultListener(result))
        }

        private fun sendDirectMessage(call: MethodCall, result: Result,hmssdk:HMSSDK) {
            val message = call.argument<String>("message") ?:
            run{
                HMSErrorLogger.logError("sendDirectMessage", "message is null", "Parameter Error")
                result.success(HMSExceptionExtension.getError("message is null in sendDirectMessage"))
                return
            }
            val peerId = call.argument<String>("peer_id") ?:
            run {
                HMSErrorLogger.logError("sendDirectMessage", "peerId is null", "Parameter Error")
                result.success(HMSExceptionExtension.getError("peerId is null in sendDirectMessage"))
                return
            }
            val type = call.argument<String>("type") ?: "chat"
            val peer = HMSCommonAction.getPeerById(peerId,hmssdk)
            peer ?: run{
                HMSErrorLogger.logError("sendDirectMessage", "peer is null", "changeRole Error")
                result.success(HMSExceptionExtension.getError("peer is null in sendDirectMessage"))
                return
            }
            hmssdk.sendDirectMessage(message, type, peer, getMessageResultListener(result))
        }

        private fun getMessageResultListener(result: Result) = object: HMSMessageResultListener {
            override fun onError(error: HMSException) {
                val args = HashMap<String, Any?>()
                args["event_name"] = "on_error"
                args["data"] = HMSExceptionExtension.toDictionary(error)
                if (args["data"] != null)
                    CoroutineScope(Dispatchers.Main).launch {
                        result.success(args)
                    }
            }

            override fun onSuccess(hmsMessage: HMSMessage) {
                val args = HashMap<String, Any?>()
                args["event_name"] = "on_success"
                args["message"] = HMSMessageExtension.toDictionary(hmsMessage)
                if (args["message"] != null)
                    CoroutineScope(Dispatchers.Main).launch {
                        result.success(args)
                    }
            }
        }

    }
}