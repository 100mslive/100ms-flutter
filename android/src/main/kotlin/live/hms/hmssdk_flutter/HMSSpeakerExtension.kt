package live.hms.hmssdk_flutter

import android.util.Log
import live.hms.video.sdk.models.HMSSpeaker

class HMSSpeakerExtension {
    companion object{
        fun toDictionary(speaker:HMSSpeaker?):HashMap<String,Any?>?{
            val hashMap = HashMap<String,Any?>()
            if(speaker==null)return null
            hashMap.put("audioLevel",speaker.level)
            Log.i("onAudioSpeakerAndroid",(speaker.hmsTrack).toString())
            hashMap.put("track",HMSTrackExtension.toDictionary(speaker.hmsTrack))
            hashMap.put("peer",HMSPeerExtension.toDictionary(speaker.peer))
            return hashMap
        }
    }
}