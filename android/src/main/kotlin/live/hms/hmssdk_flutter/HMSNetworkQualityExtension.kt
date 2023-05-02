package live.hms.hmssdk_flutter

import live.hms.video.connection.stats.quality.HMSNetworkQuality
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.enums.HMSPeerUpdate

class HMSNetworkQualityExtension {

    companion object {
        fun toDictionary(quality: HMSNetworkQuality?): HashMap<String, Any?>? {
            val args = HashMap<String, Any?>()
            if (quality == null) return null
            args["quality"] = quality.downlinkQuality
            return args
        }
    }
}