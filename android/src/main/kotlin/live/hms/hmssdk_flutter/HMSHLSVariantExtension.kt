package live.hms.hmssdk_flutter

import live.hms.video.error.HMSException
import live.hms.video.sdk.models.HMSHLSVariant
import java.text.SimpleDateFormat

class HMSHLSVariantExtension {
    companion object{
        fun toDictionary(hmshlsVariant: HMSHLSVariant?):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if (hmshlsVariant == null)return null
            args["hls_stream_url"] = hmshlsVariant.hlsStreamUrl?:""
            args["meeting_url"] = hmshlsVariant.meetingUrl?:""
            args["metadata"] = hmshlsVariant.metadata?:""
            args["started_at"] =
                SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(hmshlsVariant.startedAt).toString()
            return args
        }
    }

}