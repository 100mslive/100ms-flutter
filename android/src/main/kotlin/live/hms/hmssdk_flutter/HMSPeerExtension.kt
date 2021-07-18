package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.enums.HMSPeerUpdate

class HMSPeerExtension {

    companion object{
        fun toDictionary(peer:HMSPeer,update:HMSPeerUpdate):HashMap<String,Any>{
            val args=HashMap<String,Any>()
            args.put("peer_id",peer.peerID)
            args.put("name",peer.name)
            args.put("is_local",peer.isLocal)
            args.put("role",peer.role)
            args.put("customer_description",peer.customerDescription)
            args.put("customer_user_id",peer.customerUserID)
            args.put("status", getValueofHMSPeerUpdate(update))
            args.put("audio_track", getAudioTrackToDictionary(peer))
            return args
        }

        fun getValueofHMSPeerUpdate(update:HMSPeerUpdate):String{
            return when(update){
                HMSPeerUpdate.PEER_JOINED-> "peerJoined"
                HMSPeerUpdate.PEER_LEFT-> "peerLeft"
                HMSPeerUpdate.AUDIO_TOGGLED-> "audioToggled"
                HMSPeerUpdate.VIDEO_TOGGLED-> "videoToggled"
                else-> "defaultUpdate"
            }
        }

        fun getAudioTrackToDictionary(peer: HMSPeer):HashMap<String,String>{
            val args=HashMap<String,String>()
            if(peer.audioTrack!=null) {
                args.put("track_id", peer.audioTrack!!.trackId)
                args.put("track_source", peer.audioTrack!!.source)
                args.put("track_description", peer.audioTrack!!.description)
                args.put("track_kind", peer.audioTrack!!.type.toString().uppercase())
            }
            return args
        }
    }
}