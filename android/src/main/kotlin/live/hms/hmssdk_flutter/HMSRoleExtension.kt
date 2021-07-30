package live.hms.hmssdk_flutter

import android.annotation.SuppressLint
import android.util.Log
import live.hms.hmssdk_flutter.hms_role_components.PermissionParamsExtension
import live.hms.hmssdk_flutter.hms_role_components.PublishParamsExtension
import live.hms.hmssdk_flutter.hms_role_components.SubscribeSettings
import live.hms.video.sdk.models.role.HMSRole
import live.hms.video.sdk.models.role.PermissionsParams
import kotlin.jvm.internal.Intrinsics

class HMSRoleExtension {
    companion object{
        @SuppressLint("LongLogTag")
        fun toDictionary(role:HMSRole?):HashMap<String,Any?>?{

            val hashMap=HashMap<String,Any?>()
            if(role==null)return null
            Log.i("HMSROLE",role.toString()+"AAAAAAAAAAAAAAAAAAA")
            hashMap.put("name",role?.name?:"unknown")
            hashMap.put("publish_settings",PublishParamsExtension.toDictionary(role?.publishParams?:null))
            hashMap.put("subscribe_settings",SubscribeSettings.toDictionary(role?.subscribeParams?:null))
            hashMap.put("priority", role?.priority!!)
            hashMap.put("general_permissions",null)
            hashMap.put("internal_plugins",null)
            hashMap.put( "external_plugins",null)
            hashMap.put( "permissions",PermissionParamsExtension.toDictionary(role.permission?:null))
            Log.i("HMSROLE",hashMap.toString()+"AAAAAAAAAAAAAAAAAAAHHRR")
            return hashMap
        }
    }
}