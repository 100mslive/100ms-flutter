package live.hms.hmssdk_flutter

import android.util.Log
import live.hms.video.sdk.HMSSDK
import live.hms.video.sdk.models.HMSHLSConfig
import live.hms.video.sdk.models.HMSHLSMeetingURLVariant
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class HMSHLSAction {

    companion object{

        fun hlsActions(call: MethodCall, result: Result,hmssdk:HMSSDK){
            when (call.method) {
                "hls_start_streaming"->{
                    hlsStreaming(call, result,hmssdk)
                }
                "hls_stop_streaming"->{
                    stopHLSStreaming(call,result,hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }


        private fun hlsStreaming(call: MethodCall, result: Result,hmssdk:HMSSDK) {
            val meetingUrlVariantsList = call.argument<List<Map<String,String>>>("meeting_url_variants")

            Log.i("hlsStreaming",meetingUrlVariantsList.toString())
            val meetingUrlVariant1 : ArrayList<HMSHLSMeetingURLVariant> = ArrayList()

            meetingUrlVariantsList?.forEach {
                meetingUrlVariant1.add(
                        HMSHLSMeetingURLVariant(
                                meetingUrl = it["meeting_url"]!!,
                                metadata = it["meta_data"]!!
                        )
                )
            }

            val hlsConfig = HMSHLSConfig(meetingUrlVariant1)

            hmssdk.startHLSStreaming(config = hlsConfig, hmsActionResultListener = HMSCommonAction.getActionListener(result))
        }


        private fun stopHLSStreaming(call: MethodCall,result: Result,hmssdk:HMSSDK) {
            val meetingUrlVariantsList = call.argument<List<Map<String,String>>>("meeting_url_variants")

            val meetingUrlVariant1 : ArrayList<HMSHLSMeetingURLVariant> = ArrayList()

            meetingUrlVariantsList?.forEach {
                meetingUrlVariant1.add(
                        HMSHLSMeetingURLVariant(
                                meetingUrl = it["meeting_url"]!!,
                                metadata = it["meta_data"]!!
                        )
                )
            }

            var hlsConfig : HMSHLSConfig? = null
            if(meetingUrlVariant1.isNotEmpty())
                hlsConfig = HMSHLSConfig(meetingUrlVariant1)

            hmssdk.stopHLSStreaming(config = hlsConfig, hmsActionResultListener = HMSCommonAction.getActionListener(result))
        }

    }
}