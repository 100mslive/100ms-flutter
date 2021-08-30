package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSSpeaker

class HMSSpeakerExtension {
    companion object{
        fun toDictionary(speaker:HMSSpeaker?):HashMap<String,Any?>?{
            val hashMap = HashMap<String,Any?>()
            if(speaker==null)return null
            hashMap.put("audioLevel",speaker.level)
            hashMap.put("trackId",speaker.trackId)
            hashMap.put("peerId",speaker.peer!!.peerID)
            return hashMap
        }
    }
}