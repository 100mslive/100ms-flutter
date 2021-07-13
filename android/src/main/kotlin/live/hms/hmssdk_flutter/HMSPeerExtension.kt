package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.enums.HMSPeerUpdate

class HMSPeerExtension {

    companion object{
        fun toDictionary(peer:HMSPeer,update:HMSPeerUpdate){
            val args=HashMap<String,Any>()
            args.put("peer_id",peer.peerID)
            args.put("name",peer.name)
            args.put("is_local",peer.isLocal)
            args.put("role",peer.role)
            args.put("customer_description",peer.customerDescription)
            args.put("customer_user_id",peer.customerUserID)
            args.put("status",peer.peerID)
        }

        fun getValueofHMSPeerUpdate(update:HMSPeerUpdate):String{
            return when(update){
                HMSPeerUpdate.PEER_JOINED-> "peer joined"
                HMSPeerUpdate.PEER_LEFT-> "peerLeft"
                HMSPeerUpdate.AUDIO_TOGGLED-> "audioToggled"
                HMSPeerUpdate.VIDEO_TOGGLED-> "videoToggled"
                else-> "defaultUpdate"
            }
        }
    }
}