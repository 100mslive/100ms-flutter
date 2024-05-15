package live.hms.hmssdk_flutter

import live.hms.hmssdk_flutter.hms_role_components.PermissionParamsExtension
import live.hms.hmssdk_flutter.hms_role_components.PublishParamsExtension
import live.hms.hmssdk_flutter.hms_role_components.SubscribeSettings
import live.hms.video.sdk.models.role.HMSRole

class HMSRoleExtension {
    companion object {
        fun toDictionary(role: HMSRole?): HashMap<String, Any?>? {
            val hashMap = HashMap<String, Any?>()
            if (role == null)return null

            hashMap["name"] = role.name
            hashMap["publish_settings"] = PublishParamsExtension.toDictionary(role.publishParams)
            hashMap["subscribe_settings"] = SubscribeSettings.toDictionary(role.subscribeParams)
            hashMap["priority"] = role.priority
            hashMap["permissions"] = PermissionParamsExtension.toDictionary(role.permission)

            return hashMap
        }
    }
}
