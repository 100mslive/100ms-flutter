package live.hms.hmssdk_flutter

import live.hms.video.media.tracks.HMSTrack
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.enums.HMSTrackUpdate

class HMSTrackUpdateExtension {
    companion object{
        fun toDictionary(peer:HMSPeer,track:HMSTrack,update: HMSTrackUpdate):HashMap<String,Any>{
            val hashMap=HashMap<String,Any>()
            hashMap.put("peer", HMSPeerExtension.toDictionary(peer)!!)
            hashMap.put("track", HMSTrackExtension.toDictionary(track)!!)
            hashMap.put("update", HMSTrackExtension.getTrackUpdateInString(update)!!)
            return hashMap
        }
    }
}