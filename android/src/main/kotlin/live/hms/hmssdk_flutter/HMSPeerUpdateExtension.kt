package live.hms.hmssdk_flutter

import io.flutter.Log
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.enums.HMSPeerUpdate

class HMSPeerUpdateExtension {
    companion object{
        fun toDictionary(peer:HMSPeer?,update: HMSPeerUpdate?):HashMap<String,Any?>?{
            val args=HashMap<String,Any?>()
            if(peer==null || update==null)return null
            args.put("peer", HMSPeerExtension.toDictionary(peer)!!)

            args.put("update", HMSPeerExtension.getValueofHMSPeerUpdate(update)!!)
            return args
        }
    }
}