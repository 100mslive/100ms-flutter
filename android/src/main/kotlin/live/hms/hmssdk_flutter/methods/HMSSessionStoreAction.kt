package live.hms.hmssdk_flutter.methods

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.hmssdk_flutter.HMSCommonAction
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.hmssdk_flutter.HMSResultExtension
import live.hms.video.error.HMSException
import live.hms.video.sdk.HMSSessionMetadataListener
import live.hms.video.sessionstore.HmsSessionStore

class HMSSessionStoreAction {

    companion object{

        fun sessionStoreActions(call: MethodCall, result: Result, hmsSessionStore: HmsSessionStore?){
            when(call.method){
                "get_session_metadata_for_key" -> {
                    getSessionMetadataForKey(call,result,hmsSessionStore)
                }
                "set_session_metadata_for_key" -> {
                    setSessionMetadataForKey(call,result,hmsSessionStore)
                }
            }
        }

        private fun getSessionMetadataForKey(call: MethodCall,result: Result,hmsSessionStore: HmsSessionStore?){
            val key = call.argument<String?>("key") ?: run {
                HMSErrorLogger.returnArgumentsError("key is null")
            }

            key?.let { key as String
                hmsSessionStore?.get(key,object:HMSSessionMetadataListener{
                    override fun onError(error: HMSException) {
                        result.success(HMSResultExtension.toDictionary(false,HMSExceptionExtension.toDictionary(error)))
                    }

                    override fun onSuccess(sessionMetadata: String?) {
                        result.success(HMSResultExtension.toDictionary(true,sessionMetadata))
                    }
                })
            }
        }

        private fun setSessionMetadataForKey(call: MethodCall,result: Result,hmsSessionStore: HmsSessionStore?){
            val key = call.argument<String?>("key") ?: run {
                HMSErrorLogger.returnArgumentsError("key is null")
            }

            val data = call.argument<String?>("data")

            key?.let { key as String
                hmsSessionStore?.set(data,key,HMSCommonAction.getActionListener(result))
            }
        }

    }
}