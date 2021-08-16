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

            hashMap["name"] = role?.name?:"unknown"
            hashMap["publish_settings"] = PublishParamsExtension.toDictionary(role?.publishParams?:null)
            hashMap["subscribe_settings"] = SubscribeSettings.toDictionary(role?.subscribeParams?:null)
            hashMap["priority"] = role?.priority!!
            hashMap["general_permissions"] = null
            hashMap["internal_plugins"] = null
            hashMap["external_plugins"] = null
            hashMap["permissions"] = PermissionParamsExtension.toDictionary(role.permission?:null)

            return hashMap
        }
    }
}