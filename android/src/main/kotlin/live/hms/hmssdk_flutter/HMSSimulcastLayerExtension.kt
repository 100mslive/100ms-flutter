package live.hms.hmssdk_flutter

import live.hms.video.media.settings.HMSLayer
import live.hms.video.media.settings.HMSSimulcastLayerDefinition

class HMSSimulcastLayerExtension {

    companion object {
        fun toDictionary(layerDefinition: HMSSimulcastLayerDefinition): HashMap<String, Any?> {
            val hashMap = HashMap<String, Any?>()

            hashMap["hms_simulcast_layer"] = getStringFromLayer(layerDefinition.layer)
            hashMap["hms_resolution"] =
                HMSVideoResolutionExtension.toDictionary(layerDefinition.resolution)
            return hashMap
        }

        fun getLayerFromString(layer: String): HMSLayer {
            return when (layer) {
                "high" -> HMSLayer.HIGH
                "medium" -> HMSLayer.MEDIUM
                "low" -> HMSLayer.LOW
                else -> HMSLayer.MEDIUM
            }
        }

        fun getStringFromLayer(layer: HMSLayer): String {
            return when (layer) {
                HMSLayer.HIGH -> "high"
                HMSLayer.MEDIUM -> "medium"
                HMSLayer.LOW -> "low"
                else -> "medium"
            }
        }
    }
}
