import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.hmssdk_flutter.HMSHLSVariantExtension
import live.hms.video.sdk.models.HMSBrowserRecordingState
import live.hms.video.sdk.models.HMSHLSStreamingState
import live.hms.video.sdk.models.HMSRtmpStreamingState
import live.hms.video.sdk.models.HMSServerRecordingState

class HMSStreamingState {
    companion object{
        fun toDictionary(hmsRtmpStreamingState: HMSRtmpStreamingState?):HashMap<String,Any?>?{
            val map = HashMap<String,Any?>()
            if(hmsRtmpStreamingState == null)return null
            map["running"] = hmsRtmpStreamingState.running
            map["error"] = HMSExceptionExtension.toDictionary(hmsRtmpStreamingState.error)
            return map
        }

        fun toDictionary(hmsServerRecordingState: HMSServerRecordingState?):HashMap<String,Any?>?{
            val map = HashMap<String,Any?>()
            if(hmsServerRecordingState == null)return null
            map["running"] = hmsServerRecordingState.running
            map["error"] = HMSExceptionExtension.toDictionary(hmsServerRecordingState.error)
            return map
        }

        fun toDictionary(hmsBrowserRecordingState: HMSBrowserRecordingState?):HashMap<String,Any?>?{
            val map = HashMap<String,Any?>()
            if(hmsBrowserRecordingState == null)return null
            map["running"] = hmsBrowserRecordingState.running
            map["error"] = HMSExceptionExtension.toDictionary(hmsBrowserRecordingState.error)
            return map
        }

        fun toDictionary(hmsHlsStreamingState: HMSHLSStreamingState?):HashMap<String,Any?>?{
            val map = HashMap<String,Any?>()
            if(hmsHlsStreamingState == null)return null
            map["running"] = hmsHlsStreamingState.running
            val args=ArrayList<Any>()
            hmsHlsStreamingState.variants?.forEach {
                args.add(HMSHLSVariantExtension.toDictionary(it)!!)
            }
            map["variants"]=args
            return map
        }
    }
}