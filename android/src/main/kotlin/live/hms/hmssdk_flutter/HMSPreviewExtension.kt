package live.hms.hmssdk_flutter

import live.hms.video.media.tracks.HMSTrack
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.HMSRoom

class HMSPreviewExtension {
    companion object{
        fun toDictionary(room: HMSRoom?,allTracks:Array<HMSTrack>?):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if(room==null || allTracks==null)return null
            args["room"] = HMSRoomExtension.toDictionary(room)!!
            val tracks=ArrayList<Any>()

            for (eachTrack in allTracks) {
                tracks.add(HMSTrackExtension.toDictionary(eachTrack)!!)
            }
            args["local_tracks"] = tracks
            return args
        }
    }
}