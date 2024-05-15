package live.hms.hmssdk_flutter

import live.hms.hls_player.HmsHlsLayer

class HMSHLSLayerExtension {
    companion object {
        fun toDictionary(hmsHLSLayer: HmsHlsLayer?): HashMap<Any, Any?>? {
            if (hmsHLSLayer == null) {
                return null
            }
            val map = HashMap<Any, Any?>()
            if (hmsHLSLayer == HmsHlsLayer.AUTO) {
                return map
            }
            (hmsHLSLayer as HmsHlsLayer.LayerInfo?)?.let {
                map["resolution"] = HMSVideoResolutionExtension.toDictionary(it.resolution)
                map["bitrate"] = it.bitrate
            }
            return map
        }
    }
}
