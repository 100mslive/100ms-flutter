package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.trackchangerequest.HMSChangeTrackStateRequest

class HMSChangeTrackStateRequestExtension {
    companion object {
        fun toDictionary(hmsChangeTrackStateRequest: HMSChangeTrackStateRequest?): HashMap<String, Any?>? {
            val hashMap = HashMap<String, Any?>()
            if (hmsChangeTrackStateRequest == null)return null
            hashMap.put("mute", hmsChangeTrackStateRequest.mute)
            hashMap.put("requested_by", HMSPeerExtension.toDictionary(hmsChangeTrackStateRequest.requestedBy))
            hashMap.put("track", HMSTrackExtension.toDictionary(hmsChangeTrackStateRequest.track))

            val args = HashMap<String, Any?>()
            args.put("track_change_request", hashMap)

            return args
        }
    }
}
