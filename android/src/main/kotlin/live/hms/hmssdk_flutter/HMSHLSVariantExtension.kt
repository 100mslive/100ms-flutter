package live.hms.hmssdk_flutter

import live.hms.video.error.HMSException
import live.hms.video.sdk.models.HMSHLSVariant

class HMSHLSVariantExtension {
    companion object{
        fun toDictionary(hmshlsVariant: HMSHLSVariant?):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if (hmshlsVariant == null)return null
            args.put("hls_stream_url",hmshlsVariant.hlsStreamUrl?:"")
            args.put("meeting_url",hmshlsVariant.meetingUrl?:"")
            args.put("metadata",hmshlsVariant.metadata?:"")
            args.put("started_at",hmshlsVariant.startedAt?:-1)


            val Args=HashMap<String,Any>()
            Args.put("variant",args)
            return Args
        }
    }
}