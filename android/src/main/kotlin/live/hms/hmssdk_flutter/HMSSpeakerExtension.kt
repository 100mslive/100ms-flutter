package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSSpeaker

class HMSSpeakerExtension {
    companion object{
        fun toDictionary(speaker:HMSSpeaker?):HashMap<String,Any?>?{
            val hashMap = HashMap<String,Any?>()
            if(speaker==null)return null
            hashMap["audioLevel"] = speaker.level
            val hmsTrackMap = HMSTrackExtension.toDictionary(speaker.hmsTrack)
            val hmsPeerMap = HMSPeerExtension.toDictionary(speaker.peer)
            if((hmsTrackMap == null) || (hmsPeerMap == null)){
                return null
            }
            hashMap["track"] = hmsTrackMap
            hashMap["peer"] = hmsPeerMap
            return hashMap
        }
    }
}