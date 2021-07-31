package live.hms.hmssdk_flutter.hms_role_components

import live.hms.video.sdk.models.role.PublishParams
import live.hms.video.sdk.models.role.SubscribeParams

class SubscribeSettings {
    companion object{
        fun toDictionary(subscribeSettings:SubscribeParams?):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if(subscribeSettings==null)return null
            args.put("max_subs_bit_rate",subscribeSettings.maxSubsBitRate)
            args.put("subscribe_to_roles",subscribeSettings.subscribeTo)
            return args
        }
    }
}