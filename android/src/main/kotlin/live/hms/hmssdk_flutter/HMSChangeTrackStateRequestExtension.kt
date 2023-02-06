package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.trackchangerequest.HMSChangeTrackStateRequest

class HMSChangeTrackStateRequestExtension {

    companion object{
        fun toDictionary(hmsChangeTrackStateRequest: HMSChangeTrackStateRequest?):HashMap<String,Any?>?{
            val hashMap = HashMap<String,Any?>()
            if(hmsChangeTrackStateRequest==null)return null
            hashMap["mute"] = hmsChangeTrackStateRequest.mute
            hashMap["requested_by"] = HMSPeerExtension.toDictionary(hmsChangeTrackStateRequest.requestedBy)
            hashMap["track"] = HMSTrackExtension.toDictionary(hmsChangeTrackStateRequest.track)

            val args=HashMap<String,Any?>()
            args["track_change_request"] = hashMap

            return  args
        }
    }
}