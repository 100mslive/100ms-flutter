
import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.hmssdk_flutter.HMSHLSVariantExtension
import live.hms.video.sdk.models.*
import java.text.SimpleDateFormat

class HMSStreamingState {
    companion object{
        fun toDictionary(hmsRtmpStreamingState: HMSRtmpStreamingState?):HashMap<String,Any?>?{
            val map = HashMap<String,Any?>()
            if(hmsRtmpStreamingState == null)return null
            map["running"] = hmsRtmpStreamingState.running
            map["error"] = HMSExceptionExtension.toDictionary(hmsRtmpStreamingState.error)
            if(hmsRtmpStreamingState.running)
            map["started_at"] = SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(hmsRtmpStreamingState.startedAt).toString()
            return map
        }

        fun toDictionary(hmsServerRecordingState: HMSServerRecordingState?):HashMap<String,Any?>?{
            val map = HashMap<String,Any?>()
            if(hmsServerRecordingState == null)return null
            map["running"] = hmsServerRecordingState.running
            map["error"] = HMSExceptionExtension.toDictionary(hmsServerRecordingState.error)
            if(hmsServerRecordingState.running)
            map["started_at"] = SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(hmsServerRecordingState.startedAt).toString()
            return map
        }

        fun toDictionary(hmsBrowserRecordingState: HMSBrowserRecordingState?):HashMap<String,Any?>?{
            val map = HashMap<String,Any?>()
            if(hmsBrowserRecordingState == null)return null
            map["running"] = hmsBrowserRecordingState.running
            map["error"] = HMSExceptionExtension.toDictionary(hmsBrowserRecordingState.error)
            if(hmsBrowserRecordingState.running)
            map["started_at"] = SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(hmsBrowserRecordingState.startedAt).toString()
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

        fun toDictionary(hmsHlsRecordingState: HmsHlsRecordingState?):HashMap<String,Any?>?{
            val map = HashMap<String,Any?>()
            if(hmsHlsRecordingState == null)return null
            map["running"] = hmsHlsRecordingState.running
            if(hmsHlsRecordingState.running == true)
            map["started_at"] = SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(hmsHlsRecordingState.startedAt).toString()
            return map
        }

    }

}
