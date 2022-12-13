package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.role.LayerParams

class HMSSimulcastLayerSettingsPolicyExtension {

    companion object {
        fun toDictionary(policy: LayerParams): HashMap<String, Any?> {
            val hashMap = HashMap<String, Any?>()

            if (policy.rid == null) {
                return hashMap
            }
            hashMap["rid"] = policy.rid
            hashMap["max_bitrate"] = policy.maxBitrate ?: 0
            hashMap["max_frame_rate"] = policy.maxFramerate ?: 0
            hashMap["scale_resolution_down_by"] = policy.scaleResolutionDownBy ?: 0
            return hashMap
        }
    }
}
