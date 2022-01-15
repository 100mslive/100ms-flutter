package live.hms.hmssdk_flutter

import android.util.Log
import live.hms.video.media.tracks.HMSTrack
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.enums.HMSTrackUpdate

class HMSTrackUpdateExtension {
    companion object{
        fun toDictionary(peer:HMSPeer?,track:HMSTrack?,update: HMSTrackUpdate?):HashMap<String,Any>?{
            val hashMap=HashMap<String,Any>()

            if(peer==null || track==null || update==null)return null

            hashMap["peer"]   = HMSPeerExtension.toDictionary(peer)!!
            hashMap["track"]  = HMSTrackExtension.toDictionary(track)!!
            hashMap["update"] = HMSTrackExtension.getTrackUpdateInString(update)!!
            return hashMap
        }
    }
}