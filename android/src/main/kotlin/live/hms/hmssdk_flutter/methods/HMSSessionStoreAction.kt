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

        /***
         * This is used to get session metadata corresponding to the provided key
         *
         * If the key is null we log the error and return from method since we have the let
         * block in place already
         *
         * This method returns [sessionMetadata] is the session metadata is available for corresponding key
         */
        private fun getSessionMetadataForKey(call: MethodCall,result: Result,hmsSessionStore: HmsSessionStore?){
            val key = call.argument<String?>("key") ?: run {
                HMSErrorLogger.returnArgumentsError("key is null")
            }

            key?.let { key as String
                hmsSessionStore?.get(key,object:HMSSessionMetadataListener{
                    override fun onError(error: HMSException) {
                        result.success(HMSResultExtension.toDictionary(false,HMSExceptionExtension.toDictionary(error)))
                    }

                    override fun onSuccess(sessionMetadata: Any?) {
                        if(sessionMetadata is String?){
                            result.success(HMSResultExtension.toDictionary(true,sessionMetadata))
                        }
                        else{
                            HMSErrorLogger.returnHMSException("getSessionMetadataForKey","Session metadata type is not compatible, Please use String? type while setting metadata","Type Incompatibility Error",result)
                        }
                    }
                })
            }
        }

        /***
         * This is used to set session metadata corresponding to the provided key
         *
         * If the key is null we log the error and return from method since we have the let
         * block in place already
         *
         * This method sets the [data] provided during the method call
         * The completion of this method is marked by actionResultListener's [onSuccess] or [onError] callback
         */
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