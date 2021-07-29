package live.hms.hmssdk_flutter

import live.hms.video.media.tracks.HMSTrack
import live.hms.video.sdk.models.HMSPeer

class HMSPreviewExtension {
    companion object{
        fun toDictionary(peer: HMSPeer, track: HMSTrack):HashMap<String,Any>{
            val args=HashMap<String,Any>()
            args.put("peer",HMSPeerExtension.toDictionary(peer)!!)
            args.put("track",HMSTrackExtension.toDictionary(track)!!)
            return  args
        }
    }
}