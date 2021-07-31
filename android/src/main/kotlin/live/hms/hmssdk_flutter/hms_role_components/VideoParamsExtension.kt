package live.hms.hmssdk_flutter.hms_role_components

import live.hms.video.media.codec.HMSAudioCodec
import live.hms.video.media.codec.HMSVideoCodec
import live.hms.video.sdk.models.role.VideoParams

class VideoParamsExtension{

    companion object{
        fun toDictionary(videoParams: VideoParams):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if (videoParams==null)return null
            args.put("bit_rate",videoParams.bitRate)
            args.put("frame_rate",videoParams.frameRate)
            args.put("width",videoParams.width)
            args.put("height",videoParams.height)
            args.put("codec", getValueOfHMSAudioCodec(videoParams.codec))
            return args
        }

        fun getValueOfHMSAudioCodec (codec: HMSVideoCodec):String{
            return when (codec) {
                HMSVideoCodec.H264->
                    "h264"
                HMSVideoCodec.VP8->
                    "vp8"
                HMSVideoCodec.VP9->
                    "vp9"
                else->
                    "defaultCodec"
            }
        }
    }
}