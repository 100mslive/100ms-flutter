package live.hms.hmssdk_flutter

import android.util.Log
import live.hms.video.sdk.models.role.HMSRole
import kotlin.jvm.internal.Intrinsics

class HMSRoleExtension {
    companion object{
        fun toDictionary(role:HMSRole?):HashMap<String,Any>{

            val hashMap=HashMap<String,Any>()

            hashMap.put("name",role?.name?:"unknown")
            hashMap.put("publish_settings","role.publishSettings")
            hashMap.put("subscribe_settings","role.subscribeSettings")
            hashMap.put("priority",role?.priority?:0)
            hashMap.put("general_permissions","")
            hashMap.put("internal_plugins","role.internalPlugins")
            hashMap.put( "external_plugins","role.externalPlugins")
            return hashMap
        }
    }
}