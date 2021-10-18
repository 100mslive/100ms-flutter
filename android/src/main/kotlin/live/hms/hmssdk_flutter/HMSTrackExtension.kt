package live.hms.hmssdk_flutter

import live.hms.video.media.tracks.HMSTrack
import live.hms.video.media.tracks.HMSTrackType
import live.hms.video.sdk.models.enums.HMSTrackUpdate

class HMSTrackExtension {
    companion object{
        fun toDictionary(track:HMSTrack?):HashMap<String,Any>?{
            val hashMap=HashMap<String,Any>()
            if(track==null)return null
            hashMap.put("track_id",track.trackId)
            hashMap.put("track_description",track.description)
            hashMap.put("track_kind", getKindInString(track.type))
            hashMap.put("track_source", track.source.uppercase())
            hashMap.put("track_mute",track.isMute)
            return hashMap
        }

        private fun getKindInString(type:HMSTrackType?):String{
            if(type==null)return ""
            return when(type){
                HMSTrackType.AUDIO->{
                    "kHMSTrackKindAudio"
                }
                HMSTrackType.VIDEO->{
                    "kHMSTrackKindVideo"
                }
                else->{
                    ""
                }
            }
        }

        fun getTrackUpdateInString(hmsTrackUpdate: HMSTrackUpdate?):String?{
            if (hmsTrackUpdate==null)return null
            return when(hmsTrackUpdate){
                HMSTrackUpdate.TRACK_UNMUTED-> "trackUnMuted"
                HMSTrackUpdate.TRACK_MUTED-> "trackMuted"
                HMSTrackUpdate.TRACK_REMOVED-> "trackRemoved"
                HMSTrackUpdate.TRACK_DESCRIPTION_CHANGED-> "trackDescriptionChanged"
                HMSTrackUpdate.TRACK_ADDED-> "trackAdded"
                else->{
                    "defaultUpdate"
                }
            }
        }
    }
}