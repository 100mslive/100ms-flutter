package live.hms.hmssdk_flutter.hms_role_components

import android.util.Log
import live.hms.video.sdk.models.role.PublishParams

class PublishParamsExtension {
    companion object{
        // TODO: check for allowed
        fun toDictionary(publishParams: PublishParams?):HashMap<String,Any?>?{
            val args=HashMap<String,Any?>()
            if(publishParams==null)return null

            publishParams.audio?.let {
                args.put("audio",AudioParamsExtension.toDictionary(publishParams.audio!!))
            }

            publishParams.video?.let {
                args.put("video",VideoParamsExtension.toDictionary(publishParams.video!!))
            }

            publishParams.screen?.let {
                args.put("screen",VideoParamsExtension.toDictionary(publishParams?.screen!!))
            }

            // TODO: add allowed list of strings parsing
            return args
        }
    }
}