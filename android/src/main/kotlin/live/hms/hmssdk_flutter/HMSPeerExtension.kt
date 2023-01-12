package live.hms.hmssdk_flutter

import android.util.Log
import live.hms.video.media.tracks.HMSTrack
import live.hms.video.sdk.models.HMSLocalPeer
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.enums.HMSPeerUpdate
import java.text.SimpleDateFormat

class HMSPeerExtension {

    companion object{
        fun toDictionary(peer: HMSPeer?):HashMap<String,Any?>?{
            val args=HashMap<String,Any?>()

            if (peer==null)return null
            args["peer_id"] = peer.peerID
            args["name"] = peer.name
            args["is_local"] = peer.isLocal
            args["role"] = HMSRoleExtension.toDictionary(peer.hmsRole)
            args["metadata"] = peer.metadata
            args["customer_user_id"] = peer.customerUserID
            args["audio_track"] = HMSTrackExtension.toDictionary(peer.audioTrack)
            args["video_track"] = HMSTrackExtension.toDictionary(peer.videoTrack)
            args["network_quality"] = HMSNetworkQualityExtension.toDictionary(peer.networkQuality)
            args["joined_at"] = SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(peer.joinedAt).toString()

            val auxTrackList=ArrayList<Any>()
            peer.auxiliaryTracks.forEach {
                auxTrackList.add(HMSTrackExtension.toDictionary(it)!!)
            }
            args["auxilary_tracks"] = auxTrackList
            return args
        }

        fun getValueofHMSPeerUpdate(update:HMSPeerUpdate?):String?{
            if(update==null)return null

            return when(update){
                HMSPeerUpdate.PEER_JOINED-> "peerJoined"
                HMSPeerUpdate.PEER_LEFT-> "peerLeft"
                HMSPeerUpdate.ROLE_CHANGED-> "roleUpdated"
                HMSPeerUpdate.METADATA_CHANGED-> "metadataChanged"
                HMSPeerUpdate.NAME_CHANGED-> "nameChanged"
                HMSPeerUpdate.BECAME_DOMINANT_SPEAKER-> "becameDominantSpeaker"
                HMSPeerUpdate.NO_DOMINANT_SPEAKER-> "noDominantSpeaker"
                HMSPeerUpdate.RESIGNED_DOMINANT_SPEAKER-> "resignedDominantSpeaker"
                HMSPeerUpdate.STARTED_SPEAKING-> "startedSpeaking"
                HMSPeerUpdate.STOPPED_SPEAKING-> "stoppedSpeaking"
                HMSPeerUpdate.NETWORK_QUALITY_UPDATED->"networkQualityUpdated"
                else-> "defaultUpdate"
            }
        }
    }
}