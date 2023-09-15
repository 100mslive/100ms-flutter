package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSSpeaker

class HMSSpeakerExtension {
    companion object {
        fun toDictionary(speaker: HMSSpeaker?): HashMap<String, Any?>? {
            val hashMap = HashMap<String, Any?>()
            if (speaker == null)return null
            hashMap.put("audioLevel", speaker.level)
            val hmsTrackMap = HMSTrackExtension.toDictionary(speaker.hmsTrack)
            val hmsPeerMap = HMSPeerExtension.toDictionary(speaker.peer)
            if ((hmsTrackMap == null) || (hmsPeerMap == null)) {
                return null
            }
            hashMap.put("track", hmsTrackMap)
            hashMap.put("peer", hmsPeerMap)
            return hashMap
        }
    }
}
