package live.hms.hmssdk_flutter

import live.hms.video.media.tracks.HMSTrack
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.HMSRoom

class HMSPreviewExtension {
    companion object{
        fun toDictionary(room:HMSRoom,localTracks: Array<HMSTrack>):HashMap<String,Any>{
            val args=HashMap<String,Any>()
            args.putAll(HMSRoomExtension.toDictionary(room)!!)
            val tracks = ArrayList<Any>()
            localTracks.forEach {
                tracks.add(HMSTrackExtension.toDictionary(it)!!)
            }
            args.put("local_tracks",tracks)
            return  args
        }
    }
}