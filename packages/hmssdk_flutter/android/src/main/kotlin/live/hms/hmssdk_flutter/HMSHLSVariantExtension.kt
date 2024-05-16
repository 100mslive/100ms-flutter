package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSHLSPlaylistType
import live.hms.video.sdk.models.HMSHLSVariant

class HMSHLSVariantExtension {
    companion object {
        fun toDictionary(hmshlsVariant: HMSHLSVariant?): HashMap<String, Any>? {
            val args = HashMap<String, Any>()
            if (hmshlsVariant == null)return null
            args["hls_stream_url"] = hmshlsVariant.hlsStreamUrl ?: ""
            args["meeting_url"] = hmshlsVariant.meetingUrl ?: ""
            args["metadata"] = hmshlsVariant.metadata ?: ""
            hmshlsVariant.startedAt?.let {
                args["started_at"] = it
            }
            args["playlist_type"] = getHMSHLSVariantToString(hmshlsVariant.playlistType)
            return args
        }

        private fun getHMSHLSVariantToString(hmsHlsVariantType: HMSHLSPlaylistType?): String {
            return when (hmsHlsVariantType) {
                HMSHLSPlaylistType.dvr -> {
                    "dvr"
                }
                HMSHLSPlaylistType.noDVR -> {
                    "noDvr"
                }
                else -> {
                    "noDvr"
                }
            }
        }
    }
}
