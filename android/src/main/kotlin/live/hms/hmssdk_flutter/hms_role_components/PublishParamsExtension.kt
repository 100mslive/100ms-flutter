package live.hms.hmssdk_flutter.hms_role_components

import android.util.Log
import live.hms.video.sdk.models.role.PublishParams

class PublishParamsExtension {
    companion object{
        fun toDictionary(publishParams: PublishParams?):HashMap<String,Any?>?{
            val args=HashMap<String,Any?>()
            if(publishParams==null)return null
            args.put("audio",AudioParamsExtension.toDictionary(publishParams?.audio!!))
            args.put("video",VideoParamsExtension.toDictionary(publishParams?.video!!))
            args.put("screen",VideoParamsExtension.toDictionary(publishParams?.screen!!))
            return args
        }
    }
}