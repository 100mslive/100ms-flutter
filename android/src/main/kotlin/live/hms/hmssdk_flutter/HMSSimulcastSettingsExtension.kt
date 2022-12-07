package live.hms.hmssdk_flutter

import live.hms.video.media.settings.HMSSimulcastLayerDefinition
import live.hms.video.sdk.models.role.Simulcast

class HMSSimulcastSettingsExtension {
    companion object {
        fun toDictionary(simulcast: Simulcast): HashMap<String, Any?> {
            val hashMap = HashMap<String, Any?>()

            if(simulcast.video != null){
                hashMap["video"] = HMSSimulcastSettingsPolicyExtension.toDictionary(simulcast.video!!)
            }
            if(simulcast.screen != null){
                hashMap["screen"] = HMSSimulcastSettingsPolicyExtension.toDictionary(simulcast.screen!!)
            }
            return hashMap
        }
    }
}