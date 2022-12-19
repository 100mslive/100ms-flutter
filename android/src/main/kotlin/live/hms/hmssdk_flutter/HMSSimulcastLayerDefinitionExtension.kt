package live.hms.hmssdk_flutter

import live.hms.video.media.settings.HMSSimulcastLayerDefinition

class HMSSimulcastLayerDefinitionExtension {

    companion object{
        fun toDictionary(layerDefinition: HMSSimulcastLayerDefinition): HashMap<String, Any?> {
            val hashMap = HashMap<String, Any?>()
            hashMap["hms_simulcast_layer"] = HMSSimulcastLayerExtension.getStringFromLayer(layerDefinition.layer)
            hashMap["hms_resolution"] = HMSVideoResolutionExtension.toDictionary(layerDefinition.resolution)

            return hashMap
        }
    }
}