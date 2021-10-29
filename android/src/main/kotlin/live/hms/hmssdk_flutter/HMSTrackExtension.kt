package live.hms.hmssdk_flutter

import live.hms.video.media.tracks.HMSTrack
import live.hms.video.media.tracks.HMSTrackType
import live.hms.video.sdk.models.enums.HMSTrackUpdate

class HMSTrackExtension {
    companion object{
        fun toDictionary(track:HMSTrack?):HashMap<String,Any>?{
            val hashMap=HashMap<String,Any>()
            if(track==null)return null
            hashMap["track_id"] = track.trackId
            hashMap["track_description"] = track.description
            hashMap["track_kind"] = getKindInString(track.type)
            hashMap["track_source"] = track.source.uppercase()
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

         fun getStringFromKind(type:String?) : HMSTrackType?{
            if(type == null)return null

            return when(type){
                "kHMSTrackKindAudio"->{
                    HMSTrackType.AUDIO
                }
                "kHMSTrackKindVideo"->{
                    HMSTrackType.VIDEO
                }
                else->{
                    null
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