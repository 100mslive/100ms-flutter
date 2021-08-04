package live.hms.hmssdk_flutter

import live.hms.video.media.tracks.HMSTrack
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.HMSRoom

class HMSPreviewExtension {
    companion object{
        fun toDictionary(peer: HMSRoom,allTracks:Array<HMSTrack>):HashMap<String,Any>{
            val args=HashMap<String,Any>()
            args["room"] = HMSRoomExtension.toDictionary(peer)!!
            val tracks=ArrayList<Any>()

            for (eachTrack in allTracks) {
                tracks.add(HMSTrackExtension.toDictionary(eachTrack)!!)
            }
            args["local_tracks"] = tracks
            return  args
        }
    }
}