package live.hms.hmssdk_flutter

import android.util.Log
import live.hms.video.media.tracks.HMSTrack
import live.hms.video.sdk.models.HMSLocalPeer
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.enums.HMSPeerUpdate

class HMSPeerExtension {

    companion object{
        fun toDictionary(peer: HMSPeer?):HashMap<String,Any?>?{
            val args=HashMap<String,Any?>()

            if (peer==null)return null
            args.put("peer_id",peer.peerID)
            args.put("name",peer.name)
            args.put("is_local",peer.isLocal)
            args.put("role",HMSRoleExtension.toDictionary(peer.hmsRole))
            args.put("metadata",peer.metadata)
            args.put("customer_user_id",peer.customerUserID)
            args.put("audio_track", HMSTrackExtension.toDictionary(peer.audioTrack))
            args.put("video_track", HMSTrackExtension.toDictionary(peer.videoTrack))


            val auxTrackList=ArrayList<Any>()
            peer.auxiliaryTracks.forEach {
                auxTrackList.add(HMSTrackExtension.toDictionary(it)!!)
            }
            args.put("auxilary_tracks",auxTrackList)
            return args
        }

        fun getValueofHMSPeerUpdate(update:HMSPeerUpdate?):String?{
            if(update==null)return null

            return when(update){
                HMSPeerUpdate.PEER_JOINED-> "peerJoined"
                HMSPeerUpdate.PEER_LEFT-> "peerLeft"
                HMSPeerUpdate.AUDIO_TOGGLED-> "audioToggled"
                HMSPeerUpdate.VIDEO_TOGGLED-> "videoToggled"
                HMSPeerUpdate.ROLE_CHANGED-> "roleUpdated"
                HMSPeerUpdate.METADATA_CHANGED-> "metadataChanged"
                HMSPeerUpdate.NAME_CHANGED-> "nameChanged"
                HMSPeerUpdate.BECAME_DOMINANT_SPEAKER-> "becameDominantSpeaker"
                HMSPeerUpdate.NO_DOMINANT_SPEAKER-> "noDominantSpeaker"
                HMSPeerUpdate.RESIGNED_DOMINANT_SPEAKER-> "resignedDominantSpeaker"
                HMSPeerUpdate.STARTED_SPEAKING-> "startedSpeaking"
                HMSPeerUpdate.STOPPED_SPEAKING-> "stoppedSpeaking"
                else-> "defaultUpdate"
            }
        }
    }
}