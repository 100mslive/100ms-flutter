package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.enums.HMSPeerUpdate

class HMSPeerUpdateExtension {
    companion object{
        fun toDictionary(peer:HMSPeer?,update: HMSPeerUpdate?):HashMap<String,Any?>?{
            val args=HashMap<String,Any?>()
            if(peer==null || update==null)return null
            args["peer"] = HMSPeerExtension.toDictionary(peer)!!

            args["update"] = HMSPeerExtension.getValueOfHMSPeerUpdate(update)!!
            return args
        }
    }
}