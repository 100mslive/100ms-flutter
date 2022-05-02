package live.hms.hmssdk_flutter

import live.hms.video.media.settings.HMSVideoResolution

class HMSVideoResolutionExtension {

    companion object{

        fun toDictionary(hmsVideoResolution: HMSVideoResolution?):HashMap<String,Any?>?{

            val args=HashMap<String,Any?>()
            if(hmsVideoResolution == null) return null
            args["height"] = hmsVideoResolution.height/1.0
            args["width"] = hmsVideoResolution.width/1.0

            return args;
        }
    }
}