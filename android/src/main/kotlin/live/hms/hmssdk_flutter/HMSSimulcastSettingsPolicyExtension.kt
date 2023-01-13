package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.role.VideoSimulcastLayersParams

class HMSSimulcastSettingsPolicyExtension {

    companion object {
        fun toDictionary(layerParams: VideoSimulcastLayersParams): HashMap<String, Any?> {
            val hashMap = HashMap<String, Any?>()

            if (layerParams.layers == null) {
                return hashMap
            }
            var layers = ArrayList<HashMap<String, Any?>>()
            layerParams.layers?.let {
                layerParams.layers!!.forEach {
                    layers.add(HMSSimulcastLayerSettingsPolicyExtension.toDictionary(it))
                }
            }
            hashMap["layers"] = layers
            return hashMap
        }
    }
}
